import 'package:isar/isar.dart';

part 'sync_queue_model.g.dart';

/// Sync queue item for offline-first architecture
/// Tracks pending operations that need to be synced to server
@collection
class SyncQueueItem {
  Id id = Isar.autoIncrement;

  // Operation type
  @Enumerated(EnumType.name)
  late SyncOperation operation;

  // Target collection/entity
  late String collection;

  // Local record ID
  late int localId;

  // Server record ID (if exists)
  String? serverId;

  // Serialized data to sync
  late String dataJson;

  // Priority (lower = higher priority)
  int priority = 10;

  // Retry tracking
  int retryCount = 0;
  int maxRetries = 3;

  // Status
  @Enumerated(EnumType.name)
  late SyncStatus status;

  String? errorMessage;

  // Timestamps
  @Index()
  late DateTime createdAt;

  DateTime? lastAttemptAt;
  DateTime? completedAt;

  /// Check if should retry
  @ignore
  bool get shouldRetry => retryCount < maxRetries;

  /// Increment retry and update timestamp
  void markRetry(String error) {
    retryCount++;
    lastAttemptAt = DateTime.now();
    errorMessage = error;
    if (retryCount >= maxRetries) {
      status = SyncStatus.failed;
    }
  }

  /// Mark as completed
  void markCompleted(String? serverRecordId) {
    status = SyncStatus.completed;
    completedAt = DateTime.now();
    serverId = serverRecordId;
    errorMessage = null;
  }
}

/// Sync operation types
enum SyncOperation { create, update, delete }

/// Sync status
enum SyncStatus { pending, inProgress, completed, failed }
