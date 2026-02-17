import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/sync/sync_queue_manager.dart';
import 'package:sinergo_app/modules/history/logic/history_sync_manager.dart';
import 'package:sinergo_app/services/sync/notification_sync_manager.dart';
import 'package:sinergo_app/services/sync/master_data_sync_manager.dart';

abstract class ISyncService {
  RxBool get isSyncing;
  RxInt get pendingCount;
  RxBool get isOnline;
  RxString get syncStatus;
  Future<void> syncNow();
  Future<void> syncMasterData();
  Future<void> syncDailyAttendance(); // Added
  Future<void> retryFailedItems();
}

/// SyncService - Background sync engine for offline-first data
class SyncService extends GetxService
    with WidgetsBindingObserver
    implements ISyncService {
  final Logger _logger = Logger();

  late IIsarService _isarService;
  late IAuthService _authService;

  // Logic Managers
  late final MasterDataSyncManager _masterSync;
  late final SyncQueueManager _queueSync;
  late final NotificationSyncManager _notificationSync;

  Timer? _syncTimer;
  StreamSubscription? _connectivitySubscription;
  AppLifecycleState? _lastLifecycleState;

  static const int _syncIntervalSeconds = 30;

  // Observable state
  @override
  final RxBool isSyncing = false.obs;
  @override
  final RxInt pendingCount = 0.obs;
  @override
  final RxBool isOnline = false.obs;
  @override
  final RxString syncStatus = 'synced'.obs;

  Future<SyncService> init() async {
    _logger.i('SyncService initializing...');

    _isarService = Get.find<IIsarService>();
    _authService = Get.find<IAuthService>();

    _masterSync = MasterDataSyncManager(_authService, _isarService);
    _queueSync = SyncQueueManager(_isarService, _authService);
    _notificationSync = NotificationSyncManager(_authService, _isarService);

    WidgetsBinding.instance.addObserver(this);

    // Initial Connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    isOnline.value = !connectivityResult.contains(ConnectivityResult.none);

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.any((r) => r == ConnectivityResult.none) &&
          results.length == 1) {
        // Offline
        isOnline.value = false;
      } else {
        // Online (any valid connection)
        isOnline.value = true;
        syncNow();
      }
    });

    _startSyncTimer();
    await _updatePendingCount();

    // RECOVERY: Queue any stuck attendance records (checkout before fix)
    final recoveredCount = await _queueSync.recoverUnsyncedAttendance();
    if (recoveredCount > 0) {
      _logger.w('RECOVERY: Queued $recoveredCount stuck records for sync');
    }

    // Initial Sync
    await syncMasterData();

    return this;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        (_lastLifecycleState == AppLifecycleState.paused ||
            _lastLifecycleState == AppLifecycleState.inactive)) {
      _logger.i('🔄 AUTO-SYNC ON RESUME');
      _startSyncTimer();
      syncNow();
    }
    _lastLifecycleState = state;
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(seconds: _syncIntervalSeconds),
      (_) => syncNow(),
    );
  }

  @override
  Future<void> syncNow() async {
    if (isSyncing.value ||
        !isOnline.value ||
        !_authService.isAuthenticated.value) {
      return;
    }

    isSyncing.value = true;
    _updateStatus(); // Update status to syncing

    try {
      // Isolated: one failure doesn't block others
      try {
        await _queueSync.recoverUnsyncedAttendance();
        await _queueSync.processSyncQueue();
      } catch (e) {
        if (_isNetworkError(e)) {
          _logger.w('⚠️ Offline: Queue sync paused ($e)');
        } else {
          _logger.e('Queue sync error (isolated)', error: e);
        }
      }

      try {
        await _notificationSync.syncNotifications();
      } catch (e) {
        // NotificationSyncManager handles its own logging now, but double safety:
        if (!_isNetworkError(e)) {
          _logger.e('Notification sync error (isolated)', error: e);
        }
      }

      // 3. FULL SYNC: Sync Down Attendance History from Server
      try {
        final historySync = HistorySyncManager(_authService, _isarService);
        await historySync.fetchRemoteHistory();
      } catch (e) {
        _logger.e('History Sync Down error (isolated)', error: e);
      }
    } catch (e) {
      if (_isNetworkError(e)) {
        _logger.w('⚠️ Offline: Sync skipped ($e)');
      } else {
        _logger.e('Sync error', error: e);
      }
    } finally {
      isSyncing.value = false;
      await _updatePendingCount();
    }
  }

  bool _isNetworkError(dynamic e) {
    final s = e.toString();
    return s.contains('SocketException') ||
        s.contains('ClientException') ||
        s.contains('Network is unreachable');
  }

  @override
  Future<void> syncMasterData() async {
    if (!isOnline.value) return;
    await _masterSync.syncMasterData();
  }

  @override
  Future<void> syncDailyAttendance() async {
    if (!isOnline.value) return;
    await _masterSync.syncDailyAttendance();
  }

  Future<void> _updatePendingCount() async {
    pendingCount.value = await _queueSync.getPendingCount();
    _updateStatus();
  }

  void _updateStatus() {
    if (isSyncing.value) {
      syncStatus.value = 'syncing';
    } else if (pendingCount.value > 0) {
      syncStatus.value = 'pending';
    } else {
      syncStatus.value = 'synced';
    }
  }

  @override
  Future<void> retryFailedItems() async {
    await syncNow();
  }

  @override
  void onClose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
