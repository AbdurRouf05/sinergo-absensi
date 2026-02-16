import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/data/models/time_result_model.dart';
import 'package:sinergo_app/services/device_service.dart';
import 'package:sinergo_app/services/security_service.dart';

class CheckInValidator {
  final Logger _logger = Logger();
  final IDeviceService _deviceService;

  // Map Dart weekday (1=Mon, 7=Sun) to Indonesian day names
  static const _dayNames = {
    1: 'senin',
    2: 'selasa',
    3: 'rabu',
    4: 'kamis',
    5: 'jumat',
    6: 'sabtu',
    7: 'minggu',
  };

  CheckInValidator(this._deviceService);

  Future<void> validateRequirements({
    required OfficeLocationLocal? selectedOffice,
    required Position? currentPosition,
    required double currentDistance,
    required bool isInsideRadius,
    required TrustedTimeResult timeResult,
    required File? capturedPhoto,
    required bool isRootCheckEnabled,
    bool isGanas = false,
    String? ganasNotes,
    String? shiftEndTime, // e.g. "17:00" — if null, skip shift check
    List<String>? shiftWorkDays, // e.g. ["senin", "selasa", ...]
  }) async {
    _logger.d('🔍 Validating Check-In Rules...');

    // 0. ON-DEMAND SECURITY CHECK
    final isSafe = await Get.find<ISecurityService>().performSecurityCheck();
    if (!isSafe) {
      throw const AttendanceValidationException(
        'Pemeriksaan keamanan gagal memverifikasi integritas perangkat.',
        validationType: 'security',
      );
    }

    // 1. Hardware & Security Check (Root/Jailbreak)
    // BYPASS: Allow emulators/debug builds if specific flag (isRootCheckEnabled) is false,
    // but here we use the argument to decide.
    if (isRootCheckEnabled && !kDebugMode) {
      if (_deviceService.isDeviceCompromised.value) {
        throw const AttendanceValidationException(
          'Perangkat terdeteksi tidak aman (Root/Jailbreak).',
          validationType: 'device',
        );
      }
    }

    // 2. Location & Anti-Mock Check
    if (currentPosition == null) {
      throw const LocationException('Gagal mendapatkan lokasi GPS.');
    }

    if (currentPosition.isMocked) {
      _logger.e('FRAUD_ATTEMPT: Mock location detected!');
      throw const MockLocationException();
    }

    // 3. Geofence Check (Bypass if GANAS)
    if (selectedOffice == null) {
      throw const AttendanceValidationException(
        'Silakan pilih lokasi kantor.',
        validationType: 'gps',
      );
    }

    if (isGanas) {
      _logger.i('GANAS_MODE: Geofence check bypassed.');
      if (ganasNotes == null || ganasNotes.trim().length < 5) {
        throw const AttendanceValidationException(
          'Deskripsi tugas luar wajib diisi (minimal 5 karakter).',
          validationType: 'ganas',
        );
      }
    } else {
      if (!isInsideRadius) {
        throw AttendanceValidationException(
          'Anda berada di luar jangkauan (${currentDistance.toStringAsFixed(0)}m). '
          'Maksimal: ${selectedOffice.radius}m',
          validationType: 'gps',
        );
      }
    }

    // 4. Time Manipulation Check
    if (timeResult.isManipulated) {
      _logger.e('FRAUD_ATTEMPT: Time manipulation detected!');
      throw const TimeManipulationException(
        'Waktu sistem terdeteksi dimanipulasi.',
      );
    }

    // 5. Work Day Validation (Block Check-In on non-work days)
    if (shiftWorkDays != null && shiftWorkDays.isNotEmpty) {
      final todayName = _dayNames[timeResult.time.weekday] ?? '';
      if (!shiftWorkDays.contains(todayName)) {
        _logger.w(
            'CHECK-IN BLOCKED: Today ($todayName) is not a work day. Work days: $shiftWorkDays');
        throw AttendanceValidationException(
          'Hari ini ($todayName) bukan hari kerja shift Anda. '
          'Absen masuk tidak tersedia.',
          validationType: 'shift',
        );
      }
    }

    // 6. Shift End Time Validation (Block Check-In after shift ends)
    if (shiftEndTime != null && shiftEndTime.contains(':')) {
      try {
        final parts = shiftEndTime.split(':');
        final endHour = int.parse(parts[0]);
        final endMinute = int.parse(parts[1]);
        final now = timeResult.time;
        final shiftEnd =
            DateTime(now.year, now.month, now.day, endHour, endMinute);

        if (now.isAfter(shiftEnd)) {
          _logger.w(
              'CHECK-IN BLOCKED: Current time ${now.hour}:${now.minute} is past shift end $shiftEndTime');
          throw AttendanceValidationException(
            'Jam kerja shift Anda telah berakhir ($shiftEndTime). '
            'Anda tidak dapat melakukan absen masuk.',
            validationType: 'shift',
          );
        }
      } catch (e) {
        if (e is AttendanceValidationException) rethrow;
        _logger.w('Failed to parse shift end time: $shiftEndTime');
      }
    }

    // 6. Photo Validation
    if (capturedPhoto == null) {
      throw const AttendanceValidationException(
        'Foto wajib diambil untuk absensi.',
        validationType: 'photo',
      );
    }

    _logger.d('✅ All validations passed.');
  }
}
