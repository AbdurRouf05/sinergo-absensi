import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/models/notification_model.dart';
import 'package:sinergo_app/data/repositories/notification_repository.dart';
import 'package:sinergo_app/services/sync_service.dart';

class NotificationController extends GetxController {
  final INotificationRepository _notificationRepo =
      Get.find<INotificationRepository>();
  final ISyncService _syncService = Get.find<ISyncService>();
  final Logger _logger = Logger();

  final RxList<NotificationLocal> notifications = <NotificationLocal>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();

    // Listen to sync status to reload when data changes
    ever(_syncService.isSyncing, (bool syncing) {
      if (!syncing) loadNotifications();
    });
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final results = await _notificationRepo.getNotifications();
      notifications.assignAll(results);
      unreadCount.value = await _notificationRepo.getUnreadCount();
    } catch (e) {
      _logger.e("Notification Load Error", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(NotificationLocal notif) async {
    if (notif.isRead) return;

    try {
      await _notificationRepo.markAsRead(notif.id);

      // Local update for UI snappiness
      notif.isRead = true;
      notifications.refresh();
      unreadCount.value = await _notificationRepo.getUnreadCount();

      // Trigger sync to push read status to server
      _syncService.syncNow();
    } catch (e) {
      _logger.e("Mark Read Error", error: e);
    }
  }

  Future<void> refreshNotifications() async {
    await _syncService.syncNow();
    await loadNotifications();
  }
}
