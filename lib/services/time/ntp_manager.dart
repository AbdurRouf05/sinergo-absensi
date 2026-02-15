import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:ntp/ntp.dart';

class NtpManager {
  final Logger _logger = Logger();

  static const int _maxTimeDeviationMinutes = 2; // Max allowed deviation
  static const int _ntpTimeoutSeconds = 5;
  static const String _ntpServer = 'pool.ntp.org';

  // State
  final Rx<DateTime?> trustedTime = Rx<DateTime?>(null);
  final RxBool isTimeManipulated = false.obs;
  final RxBool isNtpAvailable = false.obs;
  final RxInt timeDeviationSeconds = 0.obs;
  final RxBool isSyncing = false.obs;

  DateTime? lastNtpTime;
  DateTime? lastLocalTimeAtNtp;

  /// Sync with NTP server
  Future<bool> syncWithNtp() async {
    isSyncing.value = true;

    try {
      _logger.i('Syncing with NTP server: $_ntpServer');

      final ntpTime = await NTP.now(
        lookUpAddress: _ntpServer,
        timeout: const Duration(seconds: _ntpTimeoutSeconds),
      );

      lastNtpTime = ntpTime;
      lastLocalTimeAtNtp = DateTime.now();
      isNtpAvailable.value = true;

      // Calculate deviation
      final deviation = ntpTime.difference(DateTime.now()).inSeconds.abs();
      timeDeviationSeconds.value = deviation;

      // Check for manipulation
      final isManipulated = deviation > (_maxTimeDeviationMinutes * 60);
      isTimeManipulated.value = isManipulated;

      if (isManipulated) {
        _logger.w(
          'TIME MANIPULATION DETECTED! '
          'Device time differs by ${deviation}s from NTP',
        );
      } else {
        _logger.i('NTP sync successful. Deviation: ${deviation}s');
      }

      trustedTime.value = ntpTime;
      return true;
    } catch (e) {
      _logger.w(
          'NTP sync failed (Timeout/Offline). Falling back to device time.',
          error: e);
      isNtpAvailable.value = false;

      // FAIL-SAFE: Trust local time if NTP fails (Emulator friendly)
      trustedTime.value = DateTime.now();
      isTimeManipulated.value = false;

      return true; // Return valid to prevent blocking
    } finally {
      isSyncing.value = false;
    }
  }
}
