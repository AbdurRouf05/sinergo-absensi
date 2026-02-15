import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:attendance_fusion/core/errors/app_exceptions.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/services/device_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/sync_service.dart';
import 'package:attendance_fusion/services/time_service.dart';
import 'package:attendance_fusion/core/constants/app_constants.dart';
import 'logic/checkin_camera_manager.dart';
import 'logic/checkin_location_manager.dart';
import 'logic/ganas_manager.dart';
import 'logic/checkin_validator.dart';
import 'logic/overtime_manager.dart';
import 'logic/checkin_action_manager.dart';
import 'logic/checkin_dialog_helper.dart';
import 'logic/office_selection_manager.dart';

class CheckinController extends GetxController {
  final Logger _logger = Logger();
  final IDeviceService _deviceService;
  final ITimeService _timeService;
  final IIsarService _isarService;
  final ISyncService _syncService;

  CheckinController({
    IDeviceService? deviceService,
    ITimeService? timeService,
    IIsarService? isarService,
    ISyncService? syncService,
  })  : _deviceService = deviceService ?? Get.find<IDeviceService>(),
        _timeService = timeService ?? Get.find<ITimeService>(),
        _isarService = isarService ?? Get.find<IIsarService>(),
        _syncService = syncService ?? Get.find<ISyncService>();

  late final CheckInLocationManager locationManager;
  late final OfficeSelectionManager selectionManager;
  late final CheckInCameraManager cameraManager;
  late final GanasManager ganasManager;
  late final OvertimeManager overtimeManager;
  late final CheckInValidator _validator;
  late final CheckinActionManager _actionManager;

  final RxBool isLoading = false.obs;
  final RxBool isCheckout = false.obs;
  final RxString formattedTime = ''.obs;
  Timer? _timer;

  Rx<OfficeLocationLocal?> get selectedOffice =>
      selectionManager.selectedOffice;
  RxList<OfficeLocationLocal> get availableOffices =>
      selectionManager.filteredOffices;
  RxDouble get currentDistance => selectionManager.currentDistance;
  RxBool get isInsideRadius => selectionManager.isInsideRadius;
  RxString get statusMessage => locationManager.statusMessage;
  Rx<dynamic> get capturedPhoto => cameraManager.capturedPhoto;
  RxBool get isCapturingPhoto => cameraManager.isCapturingPhoto;

  @override
  void onInit() {
    super.onInit();
    selectionManager = Get.put(OfficeSelectionManager());
    locationManager = Get.put(CheckInLocationManager());
    cameraManager = Get.put(CheckInCameraManager());
    ganasManager = Get.put(GanasManager());
    overtimeManager = Get.put(OvertimeManager());
    _validator = CheckInValidator(_deviceService);
    _actionManager = CheckinActionManager();

    if (Get.arguments is Map) {
      isCheckout.value = Get.arguments['isCheckout'] ?? false;
    }
    _setupGanasListeners();
    _startTimeUpdates();
  }

  void _setupGanasListeners() {
    ever(selectedOffice, (office) {
      final isGanas = office?.odId == AppConstants.officeIdGanas;
      ganasManager.activateGanas(isGanas);
    });

    // Initial check
    if (selectedOffice.value?.odId == AppConstants.officeIdGanas) {
      ganasManager.activateGanas(true);
    }
  }

  void _startTimeUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final res = await _timeService.getTrustedTime();
      formattedTime.value =
          "${res.time.hour.toString().padLeft(2, '0')}:${res.time.minute.toString().padLeft(2, '0')}:${res.time.second.toString().padLeft(2, '0')}";
    });
  }

  Future<void> capturePhoto() => cameraManager.capturePhoto();

  Future<void> validateAndSubmit() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final timeResult = await _timeService.getTrustedTime();
      final pos = await locationManager.getCurrentPosition(forceRefresh: true);

      // Fetch current user's shift end time and work days dynamically
      String? shiftEndTime;
      List<String>? shiftWorkDays;
      try {
        final authService = Get.find<IAuthService>();
        final currentUser = authService.currentUser.value;
        if (currentUser?.shiftOdId != null &&
            currentUser!.shiftOdId!.isNotEmpty) {
          final shift =
              await _isarService.getShiftByOdId(currentUser.shiftOdId!);
          shiftEndTime = shift?.endTime; // e.g. "17:00"
          shiftWorkDays = shift?.workDays; // e.g. ["senin", "selasa", ...]
        }
      } catch (e) {
        _logger.w('Could not fetch shift info: $e');
      }

      await _validator.validateRequirements(
        selectedOffice: selectedOffice.value,
        currentPosition: pos,
        currentDistance: currentDistance.value,
        isInsideRadius: isInsideRadius.value,
        timeResult: timeResult,
        capturedPhoto: cameraManager.capturedPhoto.value,
        isRootCheckEnabled: true,
        isGanas: ganasManager.isGanasActive.value,
        ganasNotes: ganasManager.ganasNotes.value,
        shiftEndTime: shiftEndTime,
        shiftWorkDays: shiftWorkDays,
      );

      if (pos == null) throw const LocationException('GPS tidak tersedia.');

      if (isCheckout.value) {
        await _handleCheckoutFlow(timeResult, pos);
      } else {
        await _actionManager.performCheckin(
          checkInTime: timeResult.time,
          isOfflineEntry: timeResult.source != TimeSource.ntp,
          selectedOffice: selectedOffice.value!,
          lat: pos.latitude,
          long: pos.longitude,
          accuracy: pos.accuracy,
          photo: cameraManager.capturedPhoto.value,
          isGanas: ganasManager.isGanasActive.value,
          ganasNotes: ganasManager.ganasNotes.value,
        );
        CheckinDialogHelper.showSuccessDialog();
      }
    } on AttendanceValidationException catch (e) {
      if (e.validationType == 'shift') {
        CheckinDialogHelper.showErrorDialog(
          title: "Absen Ditolak",
          message: e.message,
        );
      } else {
        CheckinDialogHelper.showSnackbar('Gagal', e.message, isError: true);
      }
    } on AppException catch (e) {
      CheckinDialogHelper.showSnackbar('Gagal', e.message, isError: true);
    } catch (e, stack) {
      _logger.e('Unexpected error', error: e, stackTrace: stack);
      CheckinDialogHelper.showSnackbar('Error', 'Kesalahan sistem.',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleCheckoutFlow(dynamic timeRes, Position pos) async {
    final user = await _isarService.getCurrentUser();
    // FIX: Use shiftOdId (PocketBase ID) instead of shiftId (always null)
    final shift = user?.shiftOdId != null
        ? await _isarService.getShiftByOdId(user!.shiftOdId!)
        : null;

    if (shift == null) {
      await _actionManager.performCheckout(
          checkoutTime: timeRes.time,
          lat: pos.latitude,
          long: pos.longitude,
          photo: cameraManager.capturedPhoto.value);
      CheckinDialogHelper.showSuccessDialog();
      return;
    }

    // ROBUST PARSE: Handle both 13:00 and 13.00
    final separator = shift.endTime.contains(':') ? ':' : '.';
    final shiftEndParts = shift.endTime.split(separator);

    final endHour = int.tryParse(shiftEndParts[0]) ?? 17;
    final endMinute =
        (shiftEndParts.length > 1) ? (int.tryParse(shiftEndParts[1]) ?? 0) : 0;

    final shiftEndTime = DateTime(
      timeRes.time.year,
      timeRes.time.month,
      timeRes.time.day,
      endHour,
      endMinute,
    );

    if (overtimeManager.isThresholdReached(timeRes.time, shiftEndTime)) {
      await _showOvertimeTrapDialog(timeRes.time, shiftEndTime, pos);
    } else {
      await _actionManager.performCheckout(
          checkoutTime: timeRes.time,
          lat: pos.latitude,
          long: pos.longitude,
          photo: cameraManager.capturedPhoto.value);
      CheckinDialogHelper.showSuccessDialog();
    }
  }

  Future<void> _showOvertimeTrapDialog(
      DateTime currentTime, DateTime shiftEndTime, Position pos) async {
    final Completer<void> completer = Completer();
    // Auto-checkout if context missing (background?)
    if (Get.context == null) {
      await _actionManager.performCheckout(
          checkoutTime: shiftEndTime,
          lat: pos.latitude,
          long: pos.longitude,
          photo: cameraManager.capturedPhoto.value,
          shiftEndTime: shiftEndTime);
      completer.complete();
      return completer.future;
    }

    CheckinDialogHelper.showOvertimeTrapDialog(
      onClaimOvertime: (photo, note) async {
        Get.back(); // close dialog first
        await _actionManager.performCheckout(
            checkoutTime: currentTime,
            lat: pos.latitude,
            long: pos.longitude,
            photo: photo,
            isOvertime: true,
            note: note,
            status: AttendanceStatus.pendingReview,
            shiftEndTime: shiftEndTime);
        completer.complete();
        CheckinDialogHelper.showSuccessDialog();
      },
      onRegularCheckout: () async {
        Get.back();
        await _actionManager.performCheckout(
            checkoutTime: shiftEndTime,
            lat: pos.latitude,
            long: pos.longitude,
            photo: cameraManager.capturedPhoto.value,
            shiftEndTime: shiftEndTime);
        completer.complete();
        CheckinDialogHelper.showSuccessDialog();
      },
    );
    return completer.future;
  }

  Future<void> syncData() async {
    try {
      isLoading.value = true;
      await _syncService.syncMasterData();

      // RELOAD USER & OFFICES
      final user = await _isarService.getCurrentUser();
      if (user != null) {
        Get.find<IAuthService>().currentUser.value = user;
      }
      await selectionManager.refreshOffices();

      await locationManager.getCurrentPosition(forceRefresh: true);

      CheckinDialogHelper.showSnackbar(
          'Sukses', 'Data berhasil disinkronisasi.',
          isError: false);
    } catch (e) {
      _logger.e('Manual sync error', error: e);
      CheckinDialogHelper.showSnackbar('Gagal', 'Gagal sinkronisasi: $e',
          isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    Get.delete<OfficeSelectionManager>();
    Get.delete<CheckInLocationManager>();
    Get.delete<CheckInCameraManager>();
    Get.delete<GanasManager>();
    Get.delete<OvertimeManager>();
    super.onClose();
  }
}
