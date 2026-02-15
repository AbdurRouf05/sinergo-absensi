import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/data/repositories/interfaces/i_admin_repository.dart';
import 'package:attendance_fusion/modules/admin/logic/analytics_manager.dart';
import 'package:attendance_fusion/data/models/dto/recap_row_model.dart';
import 'package:attendance_fusion/services/sync_service.dart';
import 'package:attendance_fusion/services/export_service.dart';

class AnalyticsController extends GetxController {
  final IAdminRepository _repo = Get.find<IAdminRepository>();
  final ExportService _exportService = ExportService();

  var isLoading = false.obs;
  var todayStats = Rxn<AnalyticsState>();
  var periodicRecap = <RecapRowModel>[].obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    try {
      isLoading.value = true;

      // AUTO-SYNC: Ensure we have latest data (including history)
      if (Get.isRegistered<SyncService>()) {
        await Get.find<SyncService>().syncDailyAttendance();
      }

      final now = DateTime.now();

      // Load Today's Stats
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));
      final rawToday = await _repo.fetchRawDataLocal(todayStart, todayEnd);

      todayStats.value = await compute(_calcToday, {
        ...rawToday,
        'now': now,
      });

      // Load Periodic (Last 7 days INCLUSIVE)
      // FIX: Use endOfDay to ensure today's leaves (which might start at 00:00 UTC / 07:00 WIB) are included
      // even if current time is 06:00 WIB.
      final periodicEnd = todayEnd; // 00:00 tomorrow (or use 23:59:59 today)
      // Actually fetchRawDataLocal uses < end (inclusive).
      // logic: startDate <= end.
      // If end is tomorrow 00:00.
      // Leave starts Today 00:00. Included.

      final periodicStart = todayStart
          .subtract(const Duration(days: 6)); // 7 days total (6 past + today)

      await loadPeriodicRecap(periodicStart, periodicEnd);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPeriodicRecap(DateTime start, DateTime end) async {
    startDate.value = start;
    endDate.value = end;
    final raw = await _repo.fetchRawDataLocal(start, end);

    // Add dates to data map for compute isolate
    final computeData = Map<String, dynamic>.from(raw);
    computeData['startDate'] = start;
    computeData['endDate'] = end;

    periodicRecap.value = await compute(_calcPeriodic, computeData);
  }

  void copyRecapToClipboard() {
    final text = periodicRecap.map((r) => r.toShareText()).join('\n');
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar("Sukses", "Rekap disalin ke clipboard");
  }

  Future<void> exportPdf() async {
    if (periodicRecap.isEmpty) {
      Get.snackbar("Info", "Tidak ada data untuk diexport");
      return;
    }
    await _exportService.exportPdfRecap(
      data: periodicRecap,
      startDate: startDate.value,
      endDate: endDate.value,
    );
  }

  Future<void> exportCsv() async {
    if (periodicRecap.isEmpty) {
      Get.snackbar("Info", "Tidak ada data untuk diexport");
      return;
    }
    await _exportService.exportCsvRecap(
      data: periodicRecap,
      startDate: startDate.value,
    );
  }

  // Top-level compatible static methods for compute
  static AnalyticsState _calcToday(Map<String, dynamic> data) {
    return AnalyticsManager.calculateTodayStats(
      users: data['users'],
      shifts: data['shifts'],
      attendances: data['attendances'],
      leaves: data['leaves'],
      now: data['now'],
    );
  }

  static List<RecapRowModel> _calcPeriodic(Map<String, dynamic> data) {
    return AnalyticsManager.calculatePeriodicRecap(
      users: data['users'],
      shifts: data['shifts'],
      allAttendances: data['attendances'],
      allLeaves: data['leaves'],
      startDate: data['startDate'],
      endDate: data['endDate'],
    );
  }
}
