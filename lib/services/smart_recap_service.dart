import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/auth_service.dart';

class DailyInsight {
  final String message;
  final String icon; // E.g., '🔥', '💡', '👋'
  final bool isHighlight;

  DailyInsight(this.message, this.icon, {this.isHighlight = false});
}

class SmartRecapService extends GetxService {
  final IIsarService _isarService = Get.find<IIsarService>();
  final IAuthService _authService = Get.find<IAuthService>();

  final Rx<DailyInsight?> currentInsight = Rx<DailyInsight?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Delay slightly to ensure auth is ready
    Future.delayed(const Duration(seconds: 1), () => refreshInsight());
  }

  Future<void> refreshInsight() async {
    final user = _authService.currentUser.value;
    if (user == null) {
      currentInsight.value = null;
      return;
    }

    isLoading.value = true;
    try {
      // Fetch last 30 days of attendance using the correct API
      final history =
          await _isarService.getAttendanceHistory(user.odId, limit: 30);

      if (history.isEmpty) {
        currentInsight.value = DailyInsight(
          "Selamat Datang! Mulai absen hari ini untuk membangun streak.",
          "👋",
        );
        return;
      }

      // Sort by date descending
      history.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));

      // Algorithm 1: On-Time Streak
      int streak = 0;
      // We process only unique days to prevent double counting
      final processedDays = <String>{};

      for (var record in history) {
        final dayStr = DateFormat('yyyyMMdd').format(record.checkInTime);
        if (processedDays.contains(dayStr)) continue;
        processedDays.add(dayStr);

        if (record.status == AttendanceStatus.present) {
          streak++;
        } else if (record.status == AttendanceStatus.late ||
            record.status == AttendanceStatus.absent) {
          break;
        }
      }

      // Algorithm 2: Average Check-In Time (Last 7 days)
      final last7Days =
          history.take(7).where((r) => r.checkInTime.hour < 12).toList();

      if (last7Days.isNotEmpty) {
        double totalMinutes = 0;
        for (var r in last7Days) {
          totalMinutes += r.checkInTime.hour * 60 + r.checkInTime.minute;
        }
        final avgMinutes = totalMinutes / last7Days.length;
        final avgHour = (avgMinutes / 60).floor();
        final avgMinute = (avgMinutes % 60).round();
        final avgTimeStr =
            "${avgHour.toString().padLeft(2, '0')}:${avgMinute.toString().padLeft(2, '0')}";

        if (streak > 2) {
          currentInsight.value = DailyInsight(
            "$streak Hari Tepat Waktu Beruntun! Pertahankan!",
            "🔥",
            isHighlight: true,
          );
        } else if (avgMinutes < (7 * 60 + 30)) {
          // < 07:30
          currentInsight.value = DailyInsight(
            "Kamu Early Bird! Rata-rata jam $avgTimeStr.",
            "🐦",
          );
        } else if (avgMinutes > (8 * 60)) {
          // > 08:00
          currentInsight.value = DailyInsight(
            "Tip: Coba berangkat 10 menit lebih awal. Rata-rata: $avgTimeStr.",
            "💡",
          );
        } else {
          currentInsight.value = DailyInsight(
            "Absensi kamu stabil di jam $avgTimeStr. Good job!",
            "👍",
          );
        }
      } else {
        if (streak > 0) {
          currentInsight.value = DailyInsight(
            "$streak Hari Tepat Waktu! Keep it up!",
            "🔥",
          );
        } else {
          currentInsight.value = DailyInsight(
            "Rajin pangkal pandai! Semangat kerja hari ini.",
            "💪",
          );
        }
      }
    } catch (e) {
      // Silent error or log
      currentInsight.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
