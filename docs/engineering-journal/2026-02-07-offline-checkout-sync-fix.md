# 📓 Engineering Journal: Offline Checkout Sync Fix (Trawl Net Victory)

**Date:** 2026-02-07  
**Topic:** Critical bug fix for checkout data not syncing after offline operation

## 1. The Bug

User melakukan checkout saat offline → Data tidak pernah sync ke PocketBase.

**Symptoms:**

- `out_time` di PocketBase tetap kosong
- Terminal menunjukkan `ClientException 400` pada notification sync
- History sync berjalan OK, tapi queue sync tidak jalan

## 2. Root Cause Analysis

| #   | Masalah                                                                | File                             |
| --- | ---------------------------------------------------------------------- | -------------------------------- |
| 1   | Notification filter pakai field salah (`target_user_id` vs `user_id`)  | `notification_sync_manager.dart` |
| 2   | Server-side filter menyebabkan 400 (diketahui dari journal 2026-02-04) | `notification_sync_manager.dart` |
| 3   | Checkout TIDAK masuk SyncQueue (fire-and-forget)                       | `checkout_controller.dart`       |
| 4   | Error isolation tidak ada (sequential sync)                            | `sync_service.dart`              |

## 3. The Fix

### Trawl Net Strategy

Sesuai journal 2026-02-04, solusi adalah FETCH ALL tanpa filter:

```dart
// BEFORE (Error 400)
final filter = 'target_user_id = "${user.odId}" || target_user_id = null';
pb.collection('notifications').getFullList(filter: filter);

// AFTER (Trawl Net)
final allRecords = pb.collection('notifications').getFullList(sort: '-created');
final myRecords = allRecords.where((r) {
  final uid = r.data['user_id']?.toString() ?? '';
  return uid == user.odId || uid.isEmpty;
}).toList();
```

### Checkout → SyncQueue

```dart
// Add to queue after updateCheckout
await _isarService.addToSyncQueue(SyncQueueItem()
  ..collection = 'attendance'
  ..localId = todayAttendance.value!.id
  ..operation = SyncOperation.update
  ..status = SyncStatus.pending);
```

### Auto-Recovery

```dart
// recoverUnsyncedAttendance() in SyncQueueManager
// - Finds attendance with isSynced=false
// - Queues them for retry on app startup
```

## 4. Results

- ✅ No more 400 errors
- ✅ Checkout offline now survives and syncs
- ✅ Old stuck data auto-recovered

## 5. Key Takeaways

1. **Always read engineering journal** - solution was already documented
2. **SyncQueue for EVERYTHING** - never fire-and-forget critical data
3. **Error isolation** - one failure shouldn't block others
4. **pb_schema.json outdated** - recommend re-export periodically
