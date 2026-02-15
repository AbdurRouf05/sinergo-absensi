import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // For GPS
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/sync_service.dart';

class PoskoController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();
  final IIsarService _isarService = Get.find<IIsarService>();
  final ISyncService _syncService = Get.find<ISyncService>();

  // State
  var isLoading = false.obs;
  // Change to Strong Typed List
  var poskos = <OfficeLocationLocal>[].obs;

  // Text Controllers
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPoskos();
  }

  Future<void> fetchPoskos() async {
    // 1. Instant Local Load (Offline-First)
    await _loadFromLocal();

    // 2. Background Sync (Network)
    // Don't wait for it to finish to show UI, but do update UI when done
    _syncService.syncMasterData().then((_) async {
      await _loadFromLocal();
    }).catchError((e) {
      debugPrint("Background Sync Error: $e");
    });
  }

  Future<void> _loadFromLocal() async {
    final localData = await _isarService.getActiveOfficeLocations();
    // Sort by createdAt desc (newest first)
    localData.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    poskos.assignAll(localData);
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      await _syncService.syncMasterData();
      await _loadFromLocal();
    } catch (e) {
      Get.snackbar("Error", "Gagal menyegarkan data: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePosko(String id) async {
    try {
      isLoading.value = true;
      // 1. Remote Delete
      await _authService.pb.collection('office_locations').delete(id);

      // 2. Sync to update local DB (remove deleted item)
      await _syncService.syncMasterData();
      await _loadFromLocal();

      Get.snackbar("Sukses", "Posko berhasil dihapus",
          backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus posko: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  final latController = TextEditingController();
  final lngController = TextEditingController();
  final radiusController = TextEditingController(text: "100"); // Default 100m

  @override
  void onClose() {
    nameController.dispose();
    latController.dispose();
    lngController.dispose();
    radiusController.dispose();
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      // Determine position (check service enabled, permission, etc.)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      Position position = await Geolocator.getCurrentPosition();
      latController.text = position.latitude.toString();
      lngController.text = position.longitude.toString();

      Get.snackbar("Sukses", "Lokasi saat ini berhasil diambil",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil lokasi: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPosko() async {
    final name = nameController.text.trim();
    final lat = double.tryParse(latController.text.trim());
    final lng = double.tryParse(lngController.text.trim());
    // Fix: Parse as double first to handle "100.0", then round to int.
    final radiusDouble = double.tryParse(radiusController.text.trim()) ?? 100.0;
    final radius = radiusDouble.round();

    debugPrint("DEBUG POSKO: Name=$name, Lat=$lat, Lng=$lng, Radius=$radius");

    if (name.isEmpty || lat == null || lng == null) {
      Get.snackbar("Error", "Nama dan Koordinat wajib diisi valid",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // Create Office Location Record
      await _authService.pb.collection('office_locations').create(body: {
        'name': name,
        'latitude': lat,
        'longitude': lng,
        'radius':
            radius, // FIX: Was 'radius_meters', PocketBase schema uses 'radius'
      });

      Get.snackbar("Sukses", "Posko '$name' berhasil dibuat!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4));

      Get.back(); // Close form
    } catch (e) {
      Get.snackbar("Error", "Gagal membuat posko: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
