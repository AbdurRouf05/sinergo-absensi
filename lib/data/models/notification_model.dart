import 'package:isar/isar.dart';

part 'notification_model.g.dart';

@collection
class NotificationLocal {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? odId; // PocketBase ID

  late String title;
  late String message;

  // target_user_id (if null = broadcast to all)
  @Index()
  String? targetUserId;

  @Index()
  late bool isRead;

  late String type; // 'info', 'approval', etc.

  late DateTime createdAt;
  late DateTime updatedAt;

  // Sync status
  bool isSynced = true;

  @ignore
  NotificationType get typeEnum {
    switch (type.toLowerCase()) {
      case 'info':
        return NotificationType.info;
      case 'success':
        return NotificationType.success;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      default:
        return NotificationType.info;
    }
  }
}

enum NotificationType { info, success, warning, error }
