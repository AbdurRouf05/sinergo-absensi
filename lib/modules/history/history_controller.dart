import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/sync_service.dart';

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
  static const int _pageSize = 30;
  final RxBool hasMoreData = true.obs;

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
      loadHistory();
    });

    if (Get.isRegistered<ISyncService>()) {
      ever(Get.find<ISyncService>().syncStatus, (status) {
        if (status == 'synced') {
          loadHistory(loadMore: false);
        }
      });
    }
  }

  Future<void> loadHistory({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        isLoading.value = true;
        hasMoreData.value = true;
        hasError.value = false;
        errorMessage.value = '';
      }

      final user = _authService.currentUser.value;
      if (user == null) {
        hasError.value = true;
        errorMessage.value = 'Silakan login kembali';
        isLoading.value = false;
        return;
      }

      final records = await _isarService.getAttendanceHistory(
        user.odId,
        startDate: filterStartDate.value,
        endDate: filterEndDate.value,
        limit: _pageSize,
      );

      if (!loadMore) {
        attendanceRecords.assignAll(records);
        if (records.isEmpty) {
          await _syncManager.fetchRemoteHistory();
          // Reload local after sync
          _reloadLocal(user.odId);
        } else {
          _syncManager.fetchRemoteHistory().then((updated) {
            if (updated) _reloadLocal(user.odId);
          });
        }
      } else {
        attendanceRecords.addAll(records);
      }

      if (records.length < _pageSize) {
        hasMoreData.value = false;
      }
    } catch (e) {
      if (!loadMore) {
        hasError.value = true;
        errorMessage.value = 'Gagal memuat riwayat: ${e.toString()}';
      }
      _logger.e('Failed to load history', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _reloadLocal(String userId) async {
    final records = await _isarService.getAttendanceHistory(
      userId,
      startDate: filterStartDate.value,
      endDate: filterEndDate.value,
      limit: _pageSize,
    );
    attendanceRecords.assignAll(records);
  }

  Future<void> refreshHistory() async {
    await loadHistory(loadMore: false);
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
