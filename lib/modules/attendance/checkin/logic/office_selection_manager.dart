import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/location_service.dart';
import 'package:attendance_fusion/core/constants/app_constants.dart';

class OfficeSelectionManager extends GetxController {
  final IIsarService _isar = Get.find<IIsarService>();
  final IAuthService _auth = Get.find<IAuthService>();
  final ILocationService _location = Get.find<ILocationService>();

  final RxList<OfficeLocationLocal> filteredOffices =
      <OfficeLocationLocal>[].obs;
  final Rx<OfficeLocationLocal?> selectedOffice =
      Rx<OfficeLocationLocal?>(null);
  final RxDouble currentDistance = (-1.0).obs;
  final RxBool isInsideRadius = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshOffices();
  }

  Future<void> refreshOffices() async {
    final user = _auth.currentUser.value;
    final allOffices = await _isar.getActiveOfficeLocations();

    if (user == null) {
      filteredOffices.assignAll(allOffices);
    } else {
      final List<String> allowedIds = user.allowedOfficeIds ?? [];

      final allowed =
          allOffices.where((o) => allowedIds.contains(o.odId)).toList();

      // FALLBACK: If preferred list is empty, try only the primary office field
      if (allowed.isEmpty && user.officeOdId != null) {
        final primary =
            allOffices.firstWhereOrNull((o) => o.odId == user.officeOdId);
        if (primary != null) allowed.add(primary);
      }

      // Start with allowed offices
      filteredOffices.assignAll(allowed);

      // SECURITY FIX: 2026-02-14
      // Removed permissive loop that added ALL offices to the list.
      // Now strictly respects allowed_office_ids + officeOdId.
    }

    // 1.5. INJECT DYNAMIC OUTPOSTS (Titik Admin)
    final dynamicOutposts = await _isar.getActiveDynamicOutposts();
    for (var outpost in dynamicOutposts) {
      filteredOffices.add(
        OfficeLocationLocal()
          ..odId = 'outpost_${outpost.id}' // Local prefix
          ..name = '📡 ${outpost.name} (ADMIN)'
          ..lat = outpost.lat
          ..lng = outpost.lng
          ..radius = outpost.radius,
      );
    }

    // 2. INJECT GANAS VIRTUAL OFFICE
    filteredOffices.add(
      OfficeLocationLocal()
        ..odId = AppConstants.officeIdGanas
        ..name = '⚠️ TUGAS LUAR / GANAS'
        ..radius = 999999 // Effectively bypass geofence
        ..lat = 0
        ..lng = 0,
    );

    if (filteredOffices.isNotEmpty && selectedOffice.value == null) {
      selectedOffice.value = filteredOffices.first;
    }
  }

  Position? _lastPosition;

  void updateLocation(Position position) {
    _lastPosition = position;
    if (filteredOffices.isEmpty) return;

    // Smart Auto-Selection logic:
    // If not selected or current selection is far, find the nearest ONE that is within radius.
    OfficeLocationLocal? nearestWithin;
    double minDistance = double.infinity;

    for (var office in filteredOffices) {
      final dist = _location.calculateDistance(
          position.latitude, position.longitude, office.lat, office.lng);

      if (dist <= office.radius && dist < minDistance) {
        minDistance = dist;
        nearestWithin = office;
      }
    }

    // Auto-switch IF we found a better match OR nothing is selected
    if (nearestWithin != null &&
        (selectedOffice.value == null || !isInsideRadius.value)) {
      selectedOffice.value = nearestWithin;
    }

    _calculateDistanceForSelected(position);
  }

  void _calculateDistanceForSelected(Position position) {
    if (selectedOffice.value == null) return;

    final dist = _location.calculateDistance(
      position.latitude,
      position.longitude,
      selectedOffice.value!.lat,
      selectedOffice.value!.lng,
    );

    currentDistance.value = dist;

    // GANAS Override: Constant True
    if (selectedOffice.value?.odId == AppConstants.officeIdGanas) {
      isInsideRadius.value = true;
    } else {
      isInsideRadius.value = dist <= selectedOffice.value!.radius;
    }
  }

  void selectOffice(OfficeLocationLocal office) {
    selectedOffice.value = office;
    // RECALCULATE distance immediately if we have position
    if (_lastPosition != null) {
      _calculateDistanceForSelected(_lastPosition!);
    }
  }
}
