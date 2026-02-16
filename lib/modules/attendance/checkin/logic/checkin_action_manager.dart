import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/data/repositories/attendance_repository.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/device_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/wifi_service.dart';
import 'checkin_status_helper.dart';

class CheckinActionManager {
  final Logger _logger = Logger();
  final IAuthService _authService = Get.find<IAuthService>();
  final IAttendanceRepository _attendanceRepository =
      Get.find<IAttendanceRepository>();
  final IWifiService _wifiService = Get.find<IWifiService>();
  final IDeviceService _deviceService = Get.find<IDeviceService>();
  final IIsarService _isarService = Get.find<IIsarService>();
  late final CheckInStatusHelper _statusHelper;

  CheckinActionManager() {
    _statusHelper = CheckInStatusHelper(_isarService);
  }

  Future<void> performCheckin({
    required DateTime checkInTime,
    required bool isOfflineEntry,
    required OfficeLocationLocal selectedOffice,
    required double lat,
    required double long,
    required double accuracy,
    required File? photo,
    required bool isGanas,
    String? ganasNotes,
  }) async {
    // FAIRNESS LOGIC: Get status AND raw late minutes
    final statusResult = await _statusHelper.calculateStatus(checkInTime);

    final att = AttendanceLocal()
      ..userId = _authService.currentUser.value?.odId ?? ''
      ..locationId = selectedOffice.odId
      ..checkInTime = checkInTime
      ..isWifiVerified =
          await _wifiService.isConnectedToOfficeWifi(selectedOffice.bssidList)
      ..wifiBssidUsed = await _wifiService.getFormattedBssid()
      ..gpsLat = lat
      ..gpsLong = long
      ..gpsAccuracy = accuracy
      ..isOfflineEntry = isOfflineEntry
      ..deviceIdUsed = await _deviceService.getDeviceId()
      ..status = statusResult.status
      ..lateMinutes =
          statusResult.lateMinutes > 0 ? statusResult.lateMinutes : null
      ..photoLocalPath = photo?.path
      ..isGanas = isGanas
      ..ganasNotes = ganasNotes
      ..createdAt = DateTime.now()
      ..isSynced = false;

    final id = await _attendanceRepository.saveAttendanceOffline(att);
    _attendanceRepository
        .syncToCloud(id)
        .catchError((e) => _logger.w('Sync failed', error: e));
  }

  Future<void> performCheckout({
    required DateTime checkoutTime,
    required double lat,
    required double long,
    File? photo,
    bool isOvertime = false,
    String? note,
    AttendanceStatus status = AttendanceStatus.present,
    DateTime? shiftEndTime,
  }) async {
    final att = await _isarService
        .getTodayAttendance(_authService.currentUser.value!.odId);
    if (att == null) throw const DatabaseException('Data tidak ditemukan.');

    att.checkOutTime = checkoutTime;
    att.outLat = lat;
    att.outLong = long;
    att.photoOutLocalPath = photo?.path; // Only update if new photo provided?
    // Wait, CheckinController logic was using: photo?.path ?? cameraManager.capturedPhoto.value?.path
    // The controller should pass the correct photo file logic here.

    att.status = status;
    att.isOvertime = isOvertime;
    if (isOvertime) {
      att.overtimeNote = note;
      if (shiftEndTime != null) {
        final diff = checkoutTime.difference(shiftEndTime);
        att.overtimeMinutes = diff.inMinutes > 0 ? diff.inMinutes : 0;
      }
    }
    att.isSynced = false;

    await _attendanceRepository.updateAttendance(att);
  }
}
