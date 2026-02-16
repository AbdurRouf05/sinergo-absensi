import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:sinergo_app/services/device_service.dart';
import 'package:sinergo_app/services/location_service.dart';
import 'package:sinergo_app/services/time_service.dart';

class CheckoutValidator {
  final IDeviceService _deviceService;
  final ILocationService _locationService;
  final ITimeService _timeService;

  CheckoutValidator(
    this._deviceService,
    this._locationService,
    this._timeService,
  );

  Future<void> validate({
    required bool skipGps,
    required dynamic todayAttendance,
  }) async {
    // 1. Check-in Existence (handled by controller but here for safety)
    if (todayAttendance == null) {
      throw const DatabaseException('Data check-in tidak ditemukan.');
    }
    if (todayAttendance.checkOutTime != null) {
      throw const AttendanceValidationException(
        'Anda sudah check-out hari ini.',
        validationType: 'duplicate',
      );
    }

    // 2. Device Security
    if (_deviceService.isDeviceCompromised.value) {
      throw const AttendanceValidationException(
        'Perangkat terdeteksi tidak aman (Root/Jailbreak/Emulator).',
        validationType: 'device',
      );
    }

    // 3. Location (GPS)
    if (!skipGps) {
      final position =
          await _locationService.getCurrentPosition(forceRefresh: true);
      if (position == null) {
        throw const LocationException('Gagal mendapatkan lokasi GPS.');
      }
      if (position.isMocked) {
        throw const MockLocationException();
      }
    }

    // 4. Time Manipulation
    final timeResult = await _timeService.getTrustedTime();
    if (timeResult.isManipulated) {
      throw const TimeManipulationException(
        'Waktu sistem terdeteksi dimanipulasi.',
      );
    }
  }
}
