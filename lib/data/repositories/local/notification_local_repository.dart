import 'package:isar/isar.dart';
import 'package:attendance_fusion/data/models/notification_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

class NotificationLocalRepository {
  final IsarService _isarService;

  NotificationLocalRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  Future<int> saveNotification(NotificationLocal notification) async {
    return await _isar.writeTxn(() async {
      return await _isar.notificationLocals.put(notification);
    });
  }

  Future<void> saveNotifications(List<NotificationLocal> notifications) async {
    await _isar.writeTxn(() async {
      // IDEMPOTENCY FIX: Check-then-upsert to prevent unique constraint violation
      for (final n in notifications) {
        if (n.odId != null && n.odId!.isNotEmpty) {
          final existing = await _isar.notificationLocals
              .filter()
              .odIdEqualTo(n.odId)
              .findFirst();
          if (existing != null) {
            n.id = existing.id; // Reuse existing Isar ID for UPDATE
          }
        }
        await _isar.notificationLocals.put(n);
      }
    });
  }

  Future<List<NotificationLocal>> getNotifications({int? limit}) async {
    var query = _isar.notificationLocals.where().sortByCreatedAtDesc();
    if (limit != null) {
      return await query.limit(limit).findAll();
    }
    return await query.findAll();
  }

  Future<NotificationLocal?> getNotificationByOdId(String odId) async {
    return await _isar.notificationLocals
        .filter()
        .odIdEqualTo(odId)
        .findFirst();
  }

  Future<void> markNotificationAsRead(int id) async {
    await _isar.writeTxn(() async {
      final n = await _isar.notificationLocals.get(id);
      if (n != null) {
        n.isRead = true;
        n.updatedAt = DateTime.now();
        await _isar.notificationLocals.put(n);
      }
    });
  }

  Future<int> getUnreadCount() async {
    return await _isar.notificationLocals.filter().isReadEqualTo(false).count();
  }
}
