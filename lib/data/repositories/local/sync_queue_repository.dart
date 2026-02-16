import 'package:isar/isar.dart';
import 'package:sinergo_app/data/models/sync_queue_model.dart';
import 'package:sinergo_app/services/isar_service.dart';

class SyncQueueRepository {
  final IsarService _isarService;

  SyncQueueRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  /// Add item to sync queue
  Future<int> addToSyncQueue(SyncQueueItem item) async {
    return await _isar.writeTxn(() async {
      return await _isar.syncQueueItems.put(item);
    });
  }

  /// Get pending sync items
  Future<List<SyncQueueItem>> getPendingSyncItems({int? limit}) async {
    var query = _isar.syncQueueItems
        .filter()
        .statusEqualTo(SyncStatus.pending)
        .sortByPriority()
        .thenByCreatedAt();

    if (limit != null) {
      return await query.limit(limit).findAll();
    }
    return await query.findAll();
  }

  /// Update sync queue item
  Future<void> updateSyncQueueItem(SyncQueueItem item) async {
    await _isar.writeTxn(() async {
      await _isar.syncQueueItems.put(item);
    });
  }

  /// Remove completed sync items older than duration
  Future<int> cleanupSyncQueue(Duration olderThan) async {
    final cutoff = DateTime.now().subtract(olderThan);

    return await _isar.writeTxn(() async {
      return await _isar.syncQueueItems
          .filter()
          .statusEqualTo(SyncStatus.completed)
          .completedAtLessThan(cutoff)
          .deleteAll();
    });
  }

  /// Get sync queue stats
  Future<Map<SyncStatus, int>> getSyncQueueStats() async {
    final pending = await _isar.syncQueueItems
        .filter()
        .statusEqualTo(SyncStatus.pending)
        .count();
    final inProgress = await _isar.syncQueueItems
        .filter()
        .statusEqualTo(SyncStatus.inProgress)
        .count();
    final completed = await _isar.syncQueueItems
        .filter()
        .statusEqualTo(SyncStatus.completed)
        .count();
    final failed = await _isar.syncQueueItems
        .filter()
        .statusEqualTo(SyncStatus.failed)
        .count();

    return {
      SyncStatus.pending: pending,
      SyncStatus.inProgress: inProgress,
      SyncStatus.completed: completed,
      SyncStatus.failed: failed,
    };
  }
}
