import 'package:get/get.dart';
import 'package:attendance_fusion/services/location_service.dart';
import 'package:attendance_fusion/services/time_service.dart';
import 'package:attendance_fusion/services/wifi_service.dart';

class HomeDiagnosticsManager {
  final IWifiService _wifiService;
  final ILocationService _locationService;
  final ITimeService _timeService;

  final RxString wifiInfo = 'Scanning...'.obs;
  final RxString locationInfo = 'Getting location...'.obs;
  final RxString timeStatus = 'Verifying...'.obs;

  HomeDiagnosticsManager(
      this._wifiService, this._locationService, this._timeService);

  Future<void> loadDiagnostics() async {
    // 1. Wifi Info
    try {
      final bssid = await _wifiService.getFormattedBssid();
      if (bssid != null) {
        wifiInfo.value = 'Connected: $bssid';
      } else {
        wifiInfo.value = 'Not connected or Mobile Data';
      }
    } catch (e) {
      wifiInfo.value = 'Error: $e';
    }

    // 2. Location Info
    try {
      final pos = await _locationService.getCurrentPosition();
      if (pos != null) {
        final isMock = await _locationService.detectMockLocation(pos);
        locationInfo.value =
            'Lat: ${pos.latitude.toStringAsFixed(4)}, Lng: ${pos.longitude.toStringAsFixed(4)}\n'
            'Mock: ${isMock ? "YES (Blocked)" : "No"}';
      } else {
        locationInfo.value = 'Location unavailable';
      }
    } catch (e) {
      locationInfo.value = 'Loc Error: $e';
    }

    // 3. Time Status
    try {
      final trustedTime = await _timeService.getTrustedTime();
      final isManipulated = await _timeService.detectTimeManipulation();
      timeStatus.value = 'Trusted: ${trustedTime.hour}:${trustedTime.minute}\n'
          'Manipulated: ${isManipulated ? "YES" : "No"}';
    } catch (e) {
      timeStatus.value = 'Time Error: $e';
    }
  }
}
