import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/services/sync_service.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Reactive state
  final RxBool isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Connectivity Error: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // connectivity_plus v6 returns a List check if any is not none
    bool newStatus = results.any((r) => r != ConnectivityResult.none);

    // LOGIC 1: Detect Offline -> Online Transition
    if (isOnline.value == false && newStatus == true) {
      debugPrint("OFFLINE -> ONLINE DETECTED. Triggering Auto-Sync...");
      _triggerAutoSync();
    }

    isOnline.value = newStatus;
  }

  void _triggerAutoSync() {
    try {
      if (Get.isRegistered<ISyncService>()) {
        final syncService = Get.find<ISyncService>();
        debugPrint("ConnectivityService: Triggering SyncService.syncNow()...");
        syncService.syncNow();
      }
    } catch (e) {
      debugPrint("Auto-Sync Failed: $e");
    }
  }
}
