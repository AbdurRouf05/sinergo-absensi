import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sinergo_app/services/device_service.dart';
import 'package:sinergo_app/services/location_service.dart';
import 'package:sinergo_app/services/wifi_service.dart';
import 'package:sinergo_app/services/time_service.dart';
import 'package:sinergo_app/services/isar_service.dart';

import 'package:sinergo_app/data/models/attendance_model.dart';
import 'package:sinergo_app/data/models/sync_queue_model.dart';
import 'package:sinergo_app/data/repositories/attendance_repository.dart';
import 'package:sinergo_app/core/errors/app_exceptions.dart';

// Logic Components
import 'logic/checkout_camera_manager.dart';
import 'logic/checkout_validator.dart';

class CheckoutController extends GetxController {
  final Logger _logger = Logger();

  // Core Services
  final IDeviceService _deviceService;
  final ILocationService _locationService;
  final ITimeService _timeService;
  final IIsarService _isarService;
  final IAttendanceRepository _attendanceRepository;

  // Logic Managers
  late final CheckoutCameraManager cameraManager;
  late final CheckoutValidator _validator;

  // UI State
  final RxBool isLoading = false.obs;
  final RxString statusMessage = 'Menunggu...'.obs;
  final Rx<AttendanceLocal?> todayAttendance = Rx<AttendanceLocal?>(null);

  // Dev mode flag
  final RxBool skipValidation = false.obs;

  CheckoutController({
    IDeviceService? deviceService,
    ILocationService? locationService,
    IWifiService? wifiService,
    ITimeService? timeService,
    IIsarService? isarService,
    IAttendanceRepository? attendanceRepository,
  })  : _deviceService = deviceService ?? Get.find<IDeviceService>(),
        _locationService = locationService ?? Get.find<ILocationService>(),
        _timeService = timeService ?? Get.find<ITimeService>(),
        _isarService = isarService ?? Get.find<IIsarService>(),
        _attendanceRepository =
            attendanceRepository ?? Get.find<IAttendanceRepository>();

  // Camera Proxies
  Rx<File?> get capturedPhoto => cameraManager.capturedPhoto;
  RxBool get isCapturingPhoto => cameraManager.isCapturingPhoto;

  @override
  void onInit() {
    super.onInit();
    cameraManager = Get.put(CheckoutCameraManager());
    _validator =
        CheckoutValidator(_deviceService, _locationService, _timeService);

    _loadTodayAttendance();
    _checkDevMode();
  }

  void _checkDevMode() {
    final appEnv = dotenv.env['APP_ENV'] ?? 'development';
    skipValidation.value = appEnv == 'development';
  }

  Future<void> _loadTodayAttendance() async {
    try {
      final attendance = await _attendanceRepository.getTodayAttendance();
      todayAttendance.value = attendance;

      if (attendance == null) {
        statusMessage.value = 'Anda belum check-in hari ini.';
      } else if (attendance.checkOutTime != null) {
        statusMessage.value = 'Anda sudah check-out hari ini.';
      } else {
        statusMessage.value = 'Siap untuk check-out.';
      }
    } catch (e) {
      _logger.e('Failed to load today attendance', error: e);
    }
  }

  Future<void> capturePhoto() => cameraManager.capturePhoto();
  void clearPhoto() => cameraManager.clearPhoto();

  Future<void> validateAndSubmit() async {
    if (isLoading.value) return;
    if (todayAttendance.value == null ||
        todayAttendance.value!.checkOutTime != null) {
      _loadTodayAttendance(); // Refresh status
      return;
    }

    isLoading.value = true;
    statusMessage.value = 'Memvalidasi...';

    try {
      // 1. Validate
      await _validator.validate(
        skipGps: skipValidation.value,
        todayAttendance: todayAttendance.value,
      );

      // 2. Update DB
      statusMessage.value = 'Menyimpan data...';
      final timeResult = await _timeService.getTrustedTime();

      await _isarService.updateCheckout(
        todayAttendance.value!.id,
        timeResult.time,
        cameraManager.capturedPhoto.value?.path,
      );

      // 2.5 ADD TO SYNC QUEUE (Critical for offline retry!)
      await _isarService.addToSyncQueue(SyncQueueItem()
        ..collection = 'attendance'
        ..localId = todayAttendance.value!.id
        ..dataJson = '{}'
        ..operation = SyncOperation.update // UPDATE, not CREATE
        ..status = SyncStatus.pending
        ..priority = 1
        ..retryCount = 0
        ..createdAt = DateTime.now());

      statusMessage.value = 'Check-out berhasil!';

      // 3. Sync (fire-and-forget, queue handles retry)
      _attendanceRepository
          .syncToCloud(todayAttendance.value!.id)
          .catchError((e) {
        _logger.w('Sync failed, will retry in background.', error: e);
      });

      _showSnackbar('Berhasil', 'Check-out telah dicatat.');
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } on AppException catch (e) {
      _showSnackbar('Gagal', e.message, isError: true);
    } catch (e) {
      _logger.e('Unexpected error during check-out', error: e);
      _showSnackbar('Error', 'Terjadi kesalahan sistem.', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        backgroundColor:
            isError ? Get.theme.colorScheme.error : Get.theme.primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    Get.delete<CheckoutCameraManager>();
    super.onClose();
  }
}
