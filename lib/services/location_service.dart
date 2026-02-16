import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:sinergo_app/core/utils/geo_utils.dart';
import 'package:sinergo_app/services/location/mock_location_guard.dart';

/// Interface for LocationService to enable clean mocking in tests
abstract class ILocationService {
  Rx<Position?> get currentPosition;
  RxBool get isMockLocationDetected;

  Future<Position?> getCurrentPosition({bool forceRefresh = false});
  void startLocationUpdates({required Function(Position) onUpdate});
  void stopLocationUpdates();
  Stream<Position> getPositionStream(); // Added to interface
  Future<bool> detectMockLocation(Position position);
  double calculateDistance(double lat1, double lng1, double lat2, double lng2);
  bool isWithinRadius(double lat, double lng, double targetLat,
      double targetLng, double radius);
}

class LocationService extends GetxService implements ILocationService {
  final Logger _logger = Logger();
  final MockLocationGuard _mockGuard = MockLocationGuard();

  // Location settings
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 10,
  );

  StreamSubscription<Position>? _positionSubscription;

  @override
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  @override
  final RxBool isMockLocationDetected = false.obs;

  Future<LocationService> init() async {
    _logger.i('LocationService initializing...');
    await _checkPermissions();
    return this;
  }

  /// Get current position with mock detection
  @override
  Future<Position> getCurrentPosition({bool forceRefresh = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException('Layanan lokasi tidak aktif');
    }

    await _checkPermissions();

    final position = await Geolocator.getCurrentPosition(
      locationSettings: _locationSettings,
    );

    if (await isMockLocation(position)) {
      isMockLocationDetected.value = true;
      throw const MockLocationException(
          'Terdeteksi menggunakan lokasi palsu (Fake GPS)');
    }

    isMockLocationDetected.value = false;
    currentPosition.value = position;
    return position;
  }

  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Izin lokasi ditolak permanen. Silakan aktifkan di pengaturan.',
      );
    }
  }

  @override
  Future<bool> detectMockLocation(Position position) async {
    return await isMockLocation(position);
  }

  Future<bool> isMockLocation(Position position) async {
    if (!Platform.isAndroid) return false;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return _mockGuard.detectMockLocation(position, androidInfo.version.sdkInt);
  }

  @override
  void startLocationUpdates({required Function(Position) onUpdate}) {
    _positionSubscription?.cancel();
    _positionSubscription = getPositionStream().listen((position) {
      onUpdate(position);
    }, onError: (e) {
      _logger.e('Location stream error: $e');
    });
  }

  @override
  void stopLocationUpdates() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  @override
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(locationSettings: _locationSettings)
        .asyncMap((position) async {
      if (await isMockLocation(position)) {
        throw const MockLocationException('Fake GPS Detected inside stream');
      }
      currentPosition.value = position;
      return position;
    });
  }

  @override
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return GeoUtils.calculateDistance(lat1, lng1, lat2, lng2);
  }

  @override
  bool isWithinRadius(double lat, double lng, double targetLat,
      double targetLng, double radius) {
    return GeoUtils.isWithinRadius(lat, lng, targetLat, targetLng, radius);
  }
}
