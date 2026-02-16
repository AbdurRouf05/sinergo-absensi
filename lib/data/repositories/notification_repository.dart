import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/data/models/notification_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/data/models/sync_queue_model.dart';

abstract class INotificationRepository {
  Future<List<NotificationLocal>> getNotifications();
  Future<void> markAsRead(int id);
  Future<int> getUnreadCount();
  Future<void> saveNotifications(List<NotificationLocal> notifications);
  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'info',
  });
}

class NotificationRepository implements INotificationRepository {
  final IIsarService _isar = Get.find<IIsarService>();

  @override
  Future<List<NotificationLocal>> getNotifications() {
    return _isar.getNotifications();
  }

  @override
  Future<void> markAsRead(int id) async {
    // 1. Get the notification from local DB
    final notifications = await _isar.getNotifications();
    final notification = notifications.firstWhereOrNull((n) => n.id == id);
    if (notification == null) return;

    // 2. If has remote ID, sync to server FIRST
    if (notification.odId != null && notification.odId!.isNotEmpty) {
      try {
        final authService = Get.find<IAuthService>();
        await authService.pb.collection('notifications').update(
          notification.odId!,
          body: {'is_read': true},
        );
      } catch (e) {
        // Server sync failed - still update local but log error
        debugPrint('⚠️ Mark as read server sync failed: $e');
      }
    }

    // 3. Update local DB
    await _isar.markNotificationAsRead(id);
  }

  @override
  Future<int> getUnreadCount() {
    return _isar.getUnreadNotificationCount();
  }

  @override
  Future<void> saveNotifications(List<NotificationLocal> notifications) {
    return _isar.saveNotifications(notifications);
  }

  @override
  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'info',
  }) async {
    final authService = Get.find<IAuthService>();
    final currentUser = authService.currentUser.value;

    final body = {
      'target_user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': false,
      'created_by': currentUser?.id,
    };

    // 1. Try Direct Server Push (Fastest & Preferred)
    try {
      await authService.pb.collection('notifications').create(body: body);
      debugPrint('✅ Notification sent directly to server for user $userId');
      return; // Success, no need to queue locally for Admin
    } catch (e) {
      debugPrint('⚠️ Direct notification failed ($e), queuing for sync...');
    }

    // 2. Offline Fallback: Queue it
    // Note: We save to local DB mainly to generate an ID for the queue,
    // but we must mark it as NOT for this user (Admin) to see.

    final notif = NotificationLocal()
      ..targetUserId = userId
      ..title = title
      ..message = message
      ..type = type
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isRead = false
      ..isSynced = false;

    // Save to Isar and Queue
    await _isar.isar.writeTxn(() async {
      await _isar.isar.notificationLocals.put(notif);

      // JSON Encode for Sync Worker
      final jsonStr = """
      {
        "target_user_id": "$userId",
        "title": "$title",
        "message": "$message",
        "type": "$type",
        "is_read": false
      }
      """;

      // Add to Sync Queue
      final syncItem = SyncQueueItem()
        ..operation = SyncOperation.create
        ..collection = 'notifications'
        ..localId = notif.id
        ..status = SyncStatus.pending
        ..createdAt = DateTime.now()
        ..dataJson = jsonStr; // FIX: Populated JSON

      await _isar.isar.syncQueueItems.put(syncItem);
      debugPrint('📥 Notification queued for sync (Item ${syncItem.id})');
    });
  }
}
