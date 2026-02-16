import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/data/models/time_result_model.dart';
import 'package:sinergo_app/services/time/ntp_manager.dart';

export 'package:sinergo_app/data/models/time_result_model.dart';

/// Interface for TimeService to enable clean mocking in tests
abstract class ITimeService {
  Future<TrustedTimeResult> getTrustedTime();
  Future<bool> detectTimeManipulation();
}

/// TimeService - Handles time validation and anti-cheat for time manipulation
class TimeService extends GetxService implements ITimeService {
  final Logger _logger = Logger();
  final NtpManager _ntpManager = NtpManager();

  int? _bootTimeMillis;

  // Proxies for Observable States
  Rx<DateTime?> get trustedTime => _ntpManager.trustedTime;
  RxBool get isTimeManipulated => _ntpManager.isTimeManipulated;
  RxBool get isNtpAvailable => _ntpManager.isNtpAvailable;
  RxInt get timeDeviationSeconds => _ntpManager.timeDeviationSeconds;
  RxBool get isSyncing => _ntpManager.isSyncing;

  Future<TimeService> init() async {
    _logger.i('TimeService initializing...');
    _recordBootTime();
    await _ntpManager.syncWithNtp();
    return this;
  }

  void _recordBootTime() {
    try {
      _bootTimeMillis = DateTime.now().millisecondsSinceEpoch;
      _logger.i('Boot time reference recorded');
    } catch (e) {
      _logger.e('Failed to record boot time', error: e);
    }
  }

  @override
  Future<TrustedTimeResult> getTrustedTime() async {
    // 1. Check if we have recent NTP sync (< 5 mins)
    final lastNtp = _ntpManager.lastNtpTime;
    final lastLocal = _ntpManager.lastLocalTimeAtNtp;

    if (lastNtp != null && lastLocal != null) {
      final elapsed = DateTime.now().difference(lastLocal);
      if (elapsed.inMinutes < 5) {
        return TrustedTimeResult(
          time: lastNtp.add(elapsed),
          source: TimeSource.ntp,
          isManipulated: isTimeManipulated.value,
          deviationSeconds: timeDeviationSeconds.value,
        );
      }
    }

    // 2. Try Fresh Sync
    final synced = await _ntpManager.syncWithNtp();

    if (synced && trustedTime.value != null) {
      return TrustedTimeResult(
        time: trustedTime.value!,
        source: TimeSource.ntp,
        isManipulated: isTimeManipulated.value,
        deviationSeconds: timeDeviationSeconds.value,
      );
    }

    // 3. Fallback and Boot Time Check
    _validateWithBootTime();

    return TrustedTimeResult(
      time: DateTime.now(),
      source: TimeSource.local,
      isManipulated: isTimeManipulated.value,
      deviationSeconds: timeDeviationSeconds.value,
    );
  }

  void _validateWithBootTime() {
    if (_bootTimeMillis == null) return;

    final now = DateTime.now();
    final elapsedSinceBoot = now.millisecondsSinceEpoch - _bootTimeMillis!;

    if (elapsedSinceBoot < 0) {
      _logger.w('TIME MANIPULATION DETECTED via boot time check!');
      isTimeManipulated.value = true;
    }
  }

  @override
  Future<bool> detectTimeManipulation() async {
    await _ntpManager.syncWithNtp();
    return isTimeManipulated.value;
  }

  String getDeviationText() {
    final seconds = timeDeviationSeconds.value;
    if (seconds < 60) return '$seconds detik';
    final minutes = seconds ~/ 60;
    final rem = seconds % 60;
    return '$minutes menit $rem detik';
  }

  Future<Map<String, dynamic>> getTimeInfo() async {
    final result = await getTrustedTime();
    return {
      'trusted_time': result.time.toIso8601String(),
      'source': result.source.name,
      'is_manipulated': result.isManipulated,
      'deviation_seconds': result.deviationSeconds,
      'device_time': DateTime.now().toIso8601String(),
      'ntp_available': isNtpAvailable.value,
    };
  }
}
