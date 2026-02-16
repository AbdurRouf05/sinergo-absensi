import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';

class HomeSyncManager {
  final Logger _logger = Logger();
  final IAuthService _authService;
  final IIsarService _isarService;

  // UI Observables
  final RxString checkInTimeStr = '--:--'.obs;
  final RxString checkOutTimeStr = '--:--'.obs;
  final RxString attendanceStatusStr = '-'.obs;
  final RxBool hasCheckedInToday = false.obs;

  HomeSyncManager(this._authService, this._isarService);

  Future<void> checkTodayAttendance() async {
    final user = _authService.currentUser.value;
    if (user == null) return;

    final localAtt = await _isarService.getTodayAttendance(user.odId);

    // 1. Render Local First (Fast)
    if (localAtt != null) {
      _renderAttendanceToUI(
          localAtt.checkInTime, localAtt.checkOutTime, localAtt.status);
    }

    // 2. Fetch Server Background (Reliable)
    try {
      await _fetchServerToday(user, localAtt);
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException') ||
          e.toString().contains('Network is unreachable')) {
        _logger.w("⚠️ Offline: Cannot fetch today's attendance ($e)");
      } else {
        _logger.e("Sync Down Today Error", error: e);
      }
    }
  }

  Future<void> _fetchServerToday(
      UserLocal user, AttendanceLocal? localAtt) async {
    final now = DateTime.now();
    final startDayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} 00:00:00";

    // PRIVACY FIX: Add employee filter to only get THIS user's attendance
    final result = await _authService.pb.collection('attendances').getList(
        filter: "created >= '$startDayStr' && user_id = '${user.odId}'",
        sort: '-created',
        perPage: 1);

    if (result.items.isEmpty) return;

    final serverRecord = result.items.first;
    final sCheckIn =
        DateTime.tryParse(serverRecord.getStringValue('check_in_time')) ??
            DateTime.tryParse(serverRecord.get<String>('created')) ??
            now;

    final sCheckOutStr = serverRecord.getStringValue('out_time');
    final sCheckOut =
        sCheckOutStr.isNotEmpty ? DateTime.tryParse(sCheckOutStr) : null;

    final sStatusStr = serverRecord.getStringValue('status');
    final sStatus = AttendanceStatus.values.firstWhere(
        (e) => e.name == sStatusStr,
        orElse: () => AttendanceStatus.present);

    // Update UI & Local DB
    _renderAttendanceToUI(sCheckIn, sCheckOut, sStatus);

    await _saveToLocal(serverRecord, user, sCheckIn, sCheckOut, sStatus,
        localAttId: localAtt?.id);
  }

  Future<void> _saveToLocal(dynamic serverRecord, UserLocal user,
      DateTime checkIn, DateTime? checkOut, AttendanceStatus status,
      {int? localAttId}) async {
    final attToSave = AttendanceLocal()
      ..odId = serverRecord.id
      ..userId = user.odId
      ..locationId = serverRecord.getStringValue('location')
      ..checkInTime =
          checkIn // Already converted if passed from above, but ensure consistency
      ..checkOutTime = checkOut
      ..status = status
      ..isSynced = true
      ..syncedAt = DateTime.now()
      ..createdAt =
          DateTime.tryParse(serverRecord.get<String>('created'))?.toLocal() ??
              DateTime.now()
      ..isOfflineEntry = serverRecord.getBoolValue('is_offline_entry')
      ..isWifiVerified = serverRecord.getBoolValue('is_wifi_verified')
      ..deviceIdUsed = serverRecord.getStringValue('device_id').isNotEmpty
          ? serverRecord.getStringValue('device_id')
          : 'unknown'
      ..gpsLat = serverRecord.getDoubleValue('lat')
      ..gpsLong = serverRecord.getDoubleValue('long')
      ..gpsAccuracy = serverRecord.getDoubleValue('gps_accuracy')
      ..outLat = serverRecord.getDoubleValue('out_lat')
      ..outLong = serverRecord.getDoubleValue('out_long')
      ..isGanas = serverRecord.getBoolValue('is_ganas')
      ..ganasNotes = serverRecord.getStringValue('ganas_notes')
      ..isOvertime = serverRecord.getBoolValue('is_overtime')
      ..overtimeMinutes = serverRecord.getIntValue('overtime_duration')
      ..overtimeNote = serverRecord.getStringValue('overtime_note');

    if (localAttId != null) {
      attToSave.id = localAttId;
    }

    await _isarService.saveAttendance(attToSave);
  }

  void _renderAttendanceToUI(
      DateTime checkIn, DateTime? checkOut, AttendanceStatus status) {
    hasCheckedInToday.value = true;
    checkInTimeStr.value = _formatTime(checkIn);
    checkOutTimeStr.value = checkOut != null ? _formatTime(checkOut) : '--:--';
    attendanceStatusStr.value = status.name.capitalizeFirst!;
  }

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm')
        .format(dt.toLocal()); // FIX: Convert UTC to Local
  }
}
