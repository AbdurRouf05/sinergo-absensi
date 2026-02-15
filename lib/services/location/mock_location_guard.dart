import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class MockLocationGuard {
  final Logger _logger = Logger();

  Future<bool> detectMockLocation(
      Position position, int androidSdkVersion) async {
    // Method 1: Check isMocked flag (reliable on Android 12+)
    if (position.isMocked) {
      _logger.w('Mock detected via isMocked flag');
      return true;
    }

    // Method 2: Check for suspicious accuracy
    if (position.accuracy < 1.0 || position.accuracy > 500) {
      _logger.w('Suspicious accuracy: ${position.accuracy}');
    }

    // Method 3: Check for impossible speed (> 1000 km/h)
    if (position.speed > 277.78) {
      _logger.w('Impossible speed: ${position.speed} m/s');
      return true;
    }

    // Method 4: Check for impossible altitude
    if (position.altitude < -500 || position.altitude > 10000) {
      _logger.w('Suspicious altitude: ${position.altitude}m');
    }

    // Older Android checks
    if (Platform.isAndroid && androidSdkVersion < 31) {
      // Add specialized checks or bridge to FreeRasp here
    }

    return false;
  }
}
