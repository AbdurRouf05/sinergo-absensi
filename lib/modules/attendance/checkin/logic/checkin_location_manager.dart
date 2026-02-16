import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sinergo_app/services/location_service.dart';
import 'package:sinergo_app/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'office_selection_manager.dart';

class CheckInLocationManager extends GetxController {
  final Logger _logger = Logger();
  late final ILocationService _locationService;
  late final OfficeSelectionManager _selectionManager;

  final RxString statusMessage = 'Menunggu lokasi...'.obs;
  Position? lastPosition;

  CheckInLocationManager({
    ILocationService? locationService,
    OfficeSelectionManager? selectionManager,
  }) {
    _locationService = locationService ?? Get.find<ILocationService>();
    _selectionManager = selectionManager ?? Get.find<OfficeSelectionManager>();
  }

  @override
  void onInit() {
    super.onInit();
    _startLocationMonitoring();
  }

  Future<void> _startLocationMonitoring() async {
    // 0. Ensure Permissions
    final permissionService = Get.find<IPermissionService>();
    if (!permissionService.hasLocationPermission.value) {
      final status = await permissionService.requestLocationPermission();

      if (status.isPermanentlyDenied) {
        Get.defaultDialog(
          title: 'Izin Lokasi Diperlukan',
          middleText: 'Aplikasi membutuhkan izin lokasi untuk presensi.',
          textConfirm: 'Buka Pengaturan',
          textCancel: 'Batal',
          onConfirm: () {
            permissionService.openSettings();
            Get.back();
          },
        );
      }
    }

    // 1. Listen to stream
    _locationService.startLocationUpdates(onUpdate: (position) {
      lastPosition = position;
      _selectionManager.updateLocation(position);
      _updateStatus();
    });

    // 2. Force immediate initial check
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        lastPosition = position;
        _selectionManager.updateLocation(position);
        _updateStatus();
      }
    } catch (e) {
      _logger.w('Initial location check failed: $e');
    }
  }

  void _updateStatus() {
    if (_selectionManager.selectedOffice.value == null) {
      statusMessage.value = 'Tidak ada lokasi kantor tersedia';
      return;
    }

    if (_selectionManager.isInsideRadius.value) {
      statusMessage.value = 'Anda berada di dalam area presensi';
    } else {
      final dist = _selectionManager.currentDistance.value;
      statusMessage.value =
          'Anda berada di luar jangkauan (${dist.toStringAsFixed(0)}m)';
    }
  }

  Future<Position?> getCurrentPosition({bool forceRefresh = false}) async {
    final pos =
        await _locationService.getCurrentPosition(forceRefresh: forceRefresh);
    if (pos != null) {
      lastPosition = pos;
      _selectionManager.updateLocation(pos);
      _updateStatus();
    }
    return pos;
  }

  @override
  void onClose() {
    _locationService.stopLocationUpdates();
    super.onClose();
  }
}
