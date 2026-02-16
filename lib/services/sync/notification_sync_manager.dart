import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/data/models/notification_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';

class NotificationSyncManager {
  final Logger _logger = Logger();
  final IAuthService _authService;
  final IIsarService _isarService;

  NotificationSyncManager(this._authService, this._isarService);

  Future<void> syncNotifications() async {
    try {
      final user = _authService.currentUser.value;
      if (user == null) return;

      _logger.i('Syncing notifications for user: ${user.odId}');

      // SERVER-SIDE FILTER: user_id ~ 'id' (Contains)
      // This supports the new Multiple Relation schema
      final allRecords =
          await _authService.pb.collection('notifications').getFullList(
                sort: '-created',
                filter: 'user_id ~ "${user.odId}"',
              );

      _logger.i('Fetched ${allRecords.length} notifications for user');

      // CLIENT-SIDE MAPPING (Filter is done by server now, but we map carefully)
      // We map everything returned because the server filter already did the job.
      // However, if we want to be paranoid/safe:
      final myRecords = allRecords;

      final locals = myRecords.map((r) => _mapRecordToLocal(r)).toList();

      await _isarService.saveNotifications(locals);
      _logger
          .i('Successfully synced ${locals.length} notifications to local DB');
    } catch (e, stackTrace) {
      _logger.e('Failed to sync notifications',
          error: e, stackTrace: stackTrace);
    }
  }

  NotificationLocal _mapRecordToLocal(RecordModel r) {
    final data = r.data;
    return NotificationLocal()
      ..odId = r.id
      ..title = data['title']?.toString() ?? ''
      ..message = data['message']?.toString() ?? ''
      ..targetUserId = (r.data['user_id'] is List)
          ? (r.data['user_id'] as List).join(',')
          : r.data['user_id']?.toString()
      ..isRead = data['is_read'] ?? false
      ..type = data['type']?.toString() ?? 'info'
      ..createdAt = DateTime.parse(r.get<String>('created'))
      ..updatedAt = DateTime.parse(r.get<String>('updated'))
      ..isSynced = true;
  }
}
