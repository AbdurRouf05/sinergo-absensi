import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/services/isar_service.dart';

class HomeDataManager {
  final Logger _logger = Logger();
  final IAuthService _authService;
  final IIsarService _isarService;

  final RxString currentShiftName = '-'.obs;

  HomeDataManager(this._authService, this._isarService);

  Future<void> loadShift() async {
    // 1. Try Local First
    final user = _authService.currentUser.value;
    if (user?.shiftOdId != null) {
      final shift = await _isarService.getShiftByOdId(user!.shiftOdId!);
      if (shift != null) {
        currentShiftName.value =
            "${shift.name} (${shift.startTime}-${shift.endTime})";
        return;
      }
    }

    // 2. Fallback to Server Fetch if Local fails or missing
    await fetchFreshUserData();
  }

  Future<void> fetchFreshUserData() async {
    try {
      final user = _authService.currentUser.value;
      if (user == null) return;

      final pb = _authService.pb;
      final record = await pb.collection('users').getOne(
            user.odId,
            expand: 'shift', // Correct key
          );

      var shifts = record.get<List<RecordModel>>('expand.shift');
      if (shifts.isEmpty) {
        shifts =
            record.get<List<RecordModel>>('expand.assigned_shift'); // Fallback
      }

      if (shifts.isNotEmpty) {
        final firstShift = shifts.first;
        final sData = firstShift.data;
        currentShiftName.value =
            "${sData['name']} (${sData['start_time']} - ${sData['end_time']})";
      } else {
        currentShiftName.value = "Non-Shift";
      }
    } catch (e) {
      _logger.e("❌ FORCE FETCH ERROR", error: e);
    }
  }
}
