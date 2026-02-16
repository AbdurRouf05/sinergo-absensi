import 'dart:async'; // Added for StreamSubscription
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // For GPS
import 'package:latlong2/latlong.dart'; // Added for LatLng
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/sync_service.dart';
import 'package:sinergo_app/services/location_service.dart'; // Added LocationService
import 'package:sinergo_app/core/utils/map_utils.dart'; // Added MapUtils
import 'package:flutter_map/flutter_map.dart'; // Added for MapController

class PoskoController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();
  final IIsarService _isarService = Get.find<IIsarService>();
  final ISyncService _syncService = Get.find<ISyncService>();
  final ILocationService _locationService =
      Get.find<ILocationService>(); // Injected

  // State
  var isLoading = false.obs;
  // Change to Strong Typed List
  var poskos = <OfficeLocationLocal>[].obs;

  // Live Location State
  Rx<LatLng?> currentMapLocation = Rx<LatLng?>(null); // User's Blue Dot
  StreamSubscription<Position>? _positionStreamSub;

  // Map Interaction State
  final MapController mapController = MapController();
  Rx<LatLng?> pinLocation = Rx<LatLng?>(null); // The Red Pin (Office Location)

  // Text Controllers
  final nameController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final radiusController = TextEditingController(text: "100"); // Default 100m
  final mapLinkController =
      TextEditingController(); // New Controller for Map Link

  @override
  void onInit() {
    super.onInit();
    fetchPoskos();
    startLiveLocation(); // Start stream
  }

  @override
  void onClose() {
    _positionStreamSub?.cancel(); // CRITICAL: Cancel stream
    nameController.dispose();
    latController.dispose();
    lngController.dispose();
    radiusController.dispose();
    mapLinkController.dispose();
    mapController
        .dispose(); // Dispose MapController (Actually MapController doesn't need dispose in v6? Checked docs: it's a simple object, but good practice if it has streams. flutter_map 6 MapController doesn't have dispose. It's fine to leave it or remove.)
    // mapController.dispose(); // flutter_map 6.0 doesn't implement dispose.
    super.onClose();
  }

  void startLiveLocation() {
    // 1. Get initial position first (Fast UI feedback)
    _locationService.getCurrentPosition().then((pos) {
      if (pos != null) {
        _updateLocationState(pos);
        // If pin is null, set pin to current location initially?
        // Maybe only if user hasn't set it yet.
        if (pinLocation.value == null) {
          pinLocation.value = LatLng(pos.latitude, pos.longitude);
          _updateTextFields(pinLocation.value!);
        }
      }
    }).catchError((e) {
      debugPrint("Initial location error: $e");
    });

    // 2. Start Stream for smooth updates
    _positionStreamSub?.cancel();
    _positionStreamSub = _locationService.getPositionStream().listen(
      (position) {
        _updateLocationState(position);
      },
      onError: (e) {
        debugPrint("Location stream error: $e");
      },
    );
  }

  void _updateLocationState(Position pos) {
    currentMapLocation.value = LatLng(pos.latitude, pos.longitude);
    // Note: We do NOT auto-fill text controllers here to avoid overwriting user edits
    // unless it's intended for "Current Location" mode.
    // The requirement was: "Do NOT move the 'Pinned Location' marker automatically"
    // 'currentMapLocation' is likely the blue dot 'User Location'.
    // The 'Pinned Location' (Red Marker) should be separate.
    // But for initial load or "Use Current Location" button, we might want to fill them.
  }

  /// Called when user drags the map/pin
  void onMapPositionChanged(MapPosition position, bool hasGesture) {
    if (position.center != null) {
      pinLocation.value = position.center;

      // Realtime Update Text Fields during drag (Feedback Loop)
      _updateTextFields(position.center!);
    }
  }

  /// Called when map drag ends
  void onMapDragEnd(LatLng center) {
    pinLocation.value = center;
    _updateTextFields(center);
  }

  void _updateTextFields(LatLng center) {
    // Only update if value is significantly different to avoid cursor jumps
    final currentLat = double.tryParse(latController.text) ?? 0;
    final currentLng = double.tryParse(lngController.text) ?? 0;

    // Epsilon check (0.000001)
    if ((center.latitude - currentLat).abs() > 0.000001) {
      latController.text = center.latitude.toStringAsFixed(6);
    }
    if ((center.longitude - currentLng).abs() > 0.000001) {
      lngController.text = center.longitude.toStringAsFixed(6);
    }
  }

  /// Called when user taps "Use Current Location" button
  Future<void> useCurrentLocation() async {
    final loc = currentMapLocation.value;
    if (loc != null) {
      pinLocation.value = loc;
      _updateTextFields(loc);
      mapController.move(loc, 17.0); // Zoom in

      Get.snackbar("Sukses", "Menggunakan lokasi saat ini",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      // Fallback if stream hasn't emitted yet
      await getCurrentLocation();
    }
  }

  /// Parses Map Link and updates coordinates
  Future<void> pasteMapLink() async {
    String url = mapLinkController.text.trim();
    if (url.isEmpty) return;

    // Close keyboard explicitly to avoid IME interaction issues
    try {
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (_) {}

    isLoading.value = true;
    try {
      // 1. Resolve Redirects
      String fullUrl = await MapUtils.resolveShortLink(url);

      // 2. Extract Coordinates
      List<double>? coords = MapUtils.extractCoordinates(fullUrl);

      if (coords != null) {
        final target = LatLng(coords[0], coords[1]);

        // Update State
        pinLocation.value = target;
        _updateTextFields(target);

        // Move Map Camera
        mapController.move(target, 17.0);

        mapLinkController.clear(); // Clear after success

        // No Snackbar to avoid overlay crash. Visual update is enough.
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text("Gagal"),
            content: const Text("Tidak dapat menemukan koordinat dalam link."),
            actions: [
              TextButton(
                  onPressed: () => Get.back(), child: const Text("Tutup")),
            ],
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text("Gagal memproses link: $e"),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Tutup")),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Called when user manually types in Latitude/Longitude fields
  void updateMapFromText() {
    final lat = double.tryParse(latController.text);
    final lng = double.tryParse(lngController.text);

    if (lat != null && lng != null) {
      final target = LatLng(lat, lng);
      // Update pin but DO NOT update text fields again (loop prevention)
      pinLocation.value = target;
      mapController.move(target, 17.0);
    }
  }

  // Keep existing fetchPoskos...
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
      if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException') ||
          e.toString().contains('Network is unreachable')) {
        Get.snackbar("Offline", "Data lokal ditampilkan (Tidak ada internet)",
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Gagal menyegarkan data: $e",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // GOLDEN CODE: DO NOT MODIFY WITHOUT PERMISSION
  // -------------------------------------------------------------------------
  Future<void> deletePosko(String id, String name) async {
    // Dismiss keyboard first
    try {
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (_) {}

    Get.dialog(
      AlertDialog(
        title: const Text("Hapus Posko?"),
        content:
            Text("Hapus '$name'? Karyawan tidak akan bisa absen di titik ini."),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Get.back(); // CLOSE DIALOG FIRST

              isLoading.value = true;
              try {
                // 1. Remote Delete first (Master Data)
                // Handle 404 (Already Deleted) gracefully
                try {
                  await _authService.pb
                      .collection('office_locations')
                      .delete(id);
                } catch (e) {
                  // If 404, it means already deleted, so we consider it success
                  if (e.toString().contains("404")) {
                    debugPrint("Posko already deleted on server: $id");
                  } else {
                    rethrow; // Rethrow other errors
                  }
                }

                // 2. Refresh List (Sync)
                await refreshData();

                // Note: Isar local delete happens during sync usually,
                // but we can try to force clean simple list state here
                poskos.removeWhere((p) => p.odId == id);

                // Show Success Dialog (Optional, but good for feedback)
                Get.dialog(
                  AlertDialog(
                    title: const Text("Berhasil"),
                    content: const Text("Posko berhasil dihapus."),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(), child: const Text("OK")),
                    ],
                  ),
                );
              } catch (e) {
                Get.dialog(AlertDialog(
                    title: const Text("Error"),
                    content: Text("Gagal: $e"),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Tutup"))
                    ]));
              } finally {
                isLoading.value = false;
              }
            },
          ),
        ],
      ),
    );
  }

  // Re-implement getCurrentLocation as fallback or just alias
  Future<void> getCurrentLocation() async {
    // Only fetch if stream is null
    if (currentMapLocation.value != null) {
      _updateLocationState(Position(
          latitude: currentMapLocation.value!.latitude,
          longitude: currentMapLocation.value!.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0));
      // Update text fields
      latController.text = currentMapLocation.value!.latitude.toString();
      lngController.text = currentMapLocation.value!.longitude.toString();
      return;
    }

    try {
      isLoading.value = true;
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        latController.text = position.latitude.toString();
        lngController.text = position.longitude.toString();
        _updateLocationState(position);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil lokasi: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmSavePosko() async {
    // Dismiss keyboard first
    try {
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (_) {}

    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.dialog(AlertDialog(
        title: const Text("Error"),
        content: const Text("Nama Posko wajib diisi"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Tutup"))
        ],
      ));
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text("Simpan posko '$name'?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Get.back(), // Proper Close
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3D8A)),
            child:
                const Text("Ya, Simpan", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Get.back(); // CLOSE DIALOG FIRST
              _submitPosko(); // THEN EXECUTE
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _submitPosko() async {
    final name = nameController.text.trim();
    final lat = double.tryParse(latController.text.trim());
    final lng = double.tryParse(lngController.text.trim());
    final radiusDouble = double.tryParse(radiusController.text.trim()) ?? 100.0;
    final radius = radiusDouble.round();

    if (name.isEmpty || lat == null || lng == null) {
      // Use Dialog instead of Snackbar
      Get.dialog(AlertDialog(
        title: const Text("Error"),
        content: const Text("Nama dan Koordinat wajib diisi valid"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Tutup"))
        ],
      ));
      return;
    }

    try {
      isLoading.value = true;

      // Create Office Location Record
      await _authService.pb.collection('office_locations').create(body: {
        'name': name,
        'latitude': lat,
        'longitude': lng,
        'radius': radius,
      });

      // Show Success Dialog
      Get.dialog(
        AlertDialog(
          title: const Text("Berhasil"),
          content: Text("Posko '$name' berhasil disimpan."),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // EXPLICIT CLEANUP SEQUENCE
                if (Get.isDialogOpen ?? false) Get.back(); // 1. Close Dialog
                clearForm(); // 2. Clear Form
                refreshData(); // 3. Refresh List
              },
              child: const Text("Oke", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      // Show Error Dialog
      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: Text("Terjadi kesalahan: $e"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                  // refreshData(); // removed standard refresh on error to allow retry
                },
                child: const Text("Tutup")),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
  // -------------------------------------------------------------------------

  void clearForm() {
    nameController.clear();
    radiusController.text = "100";
    mapLinkController.clear();
    // Do NOT clear Lat/Lng to prevent map jumping to 0,0
  }
}
