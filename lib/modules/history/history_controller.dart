import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/sync_service.dart';

import 'logic/history_sync_manager.dart';

enum DateFilterType {
  today,
  thisWeek,
  thisMonth,
  custom,
}

class HistoryController extends GetxController {
  late final IIsarService _isarService;
  late final IAuthService _authService;
  late final HistorySyncManager _syncManager;
  final Logger _logger = Logger();

  HistoryController({IIsarService? isarService, IAuthService? authService}) {
    _isarService = isarService ?? Get.find<IIsarService>();
    _authService = authService ?? Get.find<IAuthService>();
    _syncManager = HistorySyncManager(_authService, _isarService);
  }

  // Core state
  final RxList<AttendanceLocal> attendanceRecords = <AttendanceLocal>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Filter state
  final Rx<DateTime?> filterStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> filterEndDate = Rx<DateTime?>(null);
  final Rx<DateFilterType> filterType = DateFilterType.thisMonth.obs;

  // Pagination
  static const int _pageSize = 20;
  final RxBool hasMoreData = true.obs;
  int _currentPage = 0; // Internal page counter

  @override
  void onInit() {
    super.onInit();
    final (start, end) = _calculateDateRange(DateFilterType.thisMonth);
    filterStartDate.value = start;
    filterEndDate.value = end;

    loadHistory();

    ever(filterType, (_) {
      final (start, end) = _calculateDateRange(filterType.value);
      filterStartDate.value = start;
      filterEndDate.value = end;
      // Filter change always resets pagination
      loadHistory(reset: true);
    });

    if (Get.isRegistered<ISyncService>()) {
      ever(Get.find<ISyncService>().syncStatus, (status) {
        if (status == 'synced') {
          // Sync might bring new data, but to be safe we just refresh current view
          // OR we could silently update. For now, let's keep it simple.
          loadHistory(reset: true);
        }
      });
    }
  }

  Future<void> loadHistory({bool loadMore = false, bool reset = false}) async {
    try {
      if (reset) {
        _currentPage = 0;
        attendanceRecords.clear();
        hasMoreData.value = true;
        isLoading.value = true;
        hasError.value = false;
        errorMessage.value = '';
      } else if (loadMore) {
        if (!hasMoreData.value || isLoading.value) {
          return; // Prevent duplicate calls
        }
        isLoading.value = true;
      } else {
        // Initial load (default)
        isLoading.value = true;
      }

      final user = _authService.currentUser.value;
      if (user == null) {
        hasError.value = true;
        errorMessage.value = 'Silakan login kembali';
        isLoading.value = false;
        return;
      }

      final offset = _currentPage * _pageSize;

      final records = await _isarService.getAttendanceHistory(
        user.odId,
        startDate: filterStartDate.value,
        endDate: filterEndDate.value,
        limit: _pageSize,
        offset: offset,
      );

      if (reset || !loadMore) {
        attendanceRecords.assignAll(records);
        // If empty on reset, try fetch remote once
        if (records.isEmpty && reset) {
          await _syncManager.fetchRemoteHistory();
          // Reload local after sync
          _reloadLocal(user.odId);
        }
      } else {
        attendanceRecords.addAll(records);
      }

      // Update Pagination State
      if (records.length < _pageSize) {
        hasMoreData.value = false;
      } else {
        _currentPage++;
      }
    } catch (e) {
      if (reset || !loadMore) {
        hasError.value = true;
        errorMessage.value = 'Gagal memuat riwayat: ${e.toString()}';
      }
      _logger.e('Failed to load history', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _reloadLocal(String userId) async {
    // Only reload the first page to be safe
    final records = await _isarService.getAttendanceHistory(
      userId,
      startDate: filterStartDate.value,
      endDate: filterEndDate.value,
      limit: _pageSize,
      offset: 0,
    );
    attendanceRecords.assignAll(records);
    _currentPage = 1; // Prepare for next page
  }

  Future<void> refreshHistory() async {
    // 1. Trigger manual sync (push local data to server)
    if (Get.isRegistered<ISyncService>()) {
      await Get.find<ISyncService>().syncNow();
    }

    // 2. Reload history
    await loadHistory(reset: true);
  }

  void updateDateRange(DateTime start, DateTime end) {
    filterType.value = DateFilterType.custom;
    filterStartDate.value =
        DateTime(start.year, start.month, start.day, 0, 0, 0);
    filterEndDate.value = DateTime(end.year, end.month, end.day, 23, 59, 59);
    loadHistory();
  }

  (DateTime?, DateTime?) _calculateDateRange(DateFilterType type) {
    final now = DateTime.now();
    switch (type) {
      case DateFilterType.today:
        return (
          DateTime(now.year, now.month, now.day, 0, 0, 0),
          DateTime(now.year, now.month, now.day, 23, 59, 59)
        );
      case DateFilterType.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return (
          DateTime(
              startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0),
          DateTime(now.year, now.month, now.day, 23, 59, 59)
        );
      case DateFilterType.thisMonth:
        return (
          DateTime(now.year, now.month, 1, 0, 0, 0),
          DateTime(now.year, now.month, now.day, 23, 59, 59)
        );
      case DateFilterType.custom:
        return (filterStartDate.value, filterEndDate.value);
    }
  }
}
