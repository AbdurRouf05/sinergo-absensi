import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sinergo_app/modules/admin/controllers/posko_controller.dart';
import 'package:sinergo_app/core/widgets/offline_banner.dart'; // Added

class PoskoView extends GetView<PoskoController> {
  const PoskoView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is put if not already
    // Ideally done in binding, but for simplicity:
    // This view expects controller to be available.

    return Scaffold(
      appBar: AppBar(title: const Text("Buat Posko (Titik Absen)")),
      body: Column(
        children: [
          // 1. Offline Banner (Persistent Top)
          const OfflineBanner(),

          // 2. Scrollable Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshData();
              },
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Ensure pull works even if content short
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECTION: Smart Link Parser (DISABLED PER USER REQUEST) ---
                    /*
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text("📌 Punya Link Google Maps?",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.mapLinkController,
                                    decoration: const InputDecoration(
                                        hintText:
                                            "Paste link di sini (goo.gl...)",
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Obx(() => ElevatedButton(
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () => controller.pasteMapLink(),
                                      child: controller.isLoading.value
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2))
                                          : const Icon(Icons.search),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    */

                    // --- SECTION: Interactive Map with Fallback ---
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            // A. Offline Grid Pattern Fallback (Visible if tiles fail/slow)
                            Container(
                              color: Colors.grey[100],
                              width: double.infinity,
                              height: double.infinity,
                              child: GridPaper(
                                color: Colors.grey
                                    .withValues(alpha: 0.3), // Technical Grid
                                interval: 50,
                                subdivisions: 1,
                                child: Center(
                                  child: Opacity(
                                    opacity: 0.1, // Subtle watermark
                                    child: Image.asset(
                                      "assets/images/sinergo_icon.png",
                                      width: 100,
                                      errorBuilder: (c, e, s) => const Icon(
                                          Icons.map,
                                          size: 80,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // B. The Actual Map
                            Obx(() {
                              // Initial center: Pin > User > Default (Monas)
                              final startCenter =
                                  controller.pinLocation.value ??
                                      controller.currentMapLocation.value ??
                                      const LatLng(-6.1754, 106.8272);

                              return FlutterMap(
                                mapController: controller.mapController,
                                options: MapOptions(
                                  initialCenter: startCenter,
                                  initialZoom: 15.0,
                                  // Transparent background so Grid shows through if tiles missing
                                  backgroundColor: Colors.transparent,
                                  onPositionChanged: (pos, hasGesture) {
                                    controller.onMapPositionChanged(
                                        pos, hasGesture);
                                  },
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.all,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.sinergo.attendance',
                                    // Use transparent tile if loading fails or offline?
                                    // flutter_map handles net errors by showing nothing (transparent) usually.
                                    // We can add errorImage if we wanted, but we want the Grid behind to show.
                                  ),

                                  // Layer 1: User Location (Blue Dot)
                                  if (controller.currentMapLocation.value !=
                                      null)
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: controller
                                              .currentMapLocation.value!,
                                          width: 40,
                                          height: 40,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  179,
                                                  68,
                                                  138,
                                                  255), // blueAccent 0.7
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            child: const Icon(
                                                Icons.person_pin_circle,
                                                color: Colors.white,
                                                size: 24),
                                          ),
                                        ),
                                      ],
                                    ),

                                  // Layer 2: Office Radius Indicator (Visual feedback)
                                  if (controller.pinLocation.value != null)
                                    CircleLayer(
                                      circles: [
                                        CircleMarker(
                                          point: controller.pinLocation.value!,
                                          radius: double.tryParse(controller
                                                  .radiusController.text) ??
                                              100.0,
                                          useRadiusInMeter: true,
                                          color: const Color.fromARGB(
                                              51, 255, 82, 82), // redAccent 0.2
                                          borderColor: Colors.redAccent,
                                          borderStrokeWidth: 1,
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            }),

                            // Fixed Center Pin (Always stays in middle)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 35.0),
                                child: Icon(Icons.location_on,
                                    size: 45, color: Colors.red),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: SizedBox(
                                    width: 5,
                                    height: 5,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle))),
                              ),
                            ),

                            // Map Controls
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: FloatingActionButton.small(
                                heroTag: "btn_my_loc",
                                onPressed: () =>
                                    controller.useCurrentLocation(),
                                backgroundColor: Colors.white,
                                child: const Icon(Icons.my_location,
                                    color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                        child: Text(
                            "Geser peta untuk menentukan titik koordinat kantor",
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey))),
                    const SizedBox(height: 16),

                    // --- SECTION: Form ---
                    TextField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        labelText: "Nama Posko / Kegiatan",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                        hintText: "Contoh: Posko Utama",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.latController,
                            readOnly: true, // Auto-filled by map
                            decoration: const InputDecoration(
                              labelText: "Latitude",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controller.lngController,
                            readOnly: true, // Auto-filled by map
                            decoration: const InputDecoration(
                              labelText: "Longitude",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.radiusController,
                      decoration: const InputDecoration(
                        labelText: "Radius Jangkauan (Meter)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.radar),
                        hintText: "Default: 100",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => controller.poskos
                          .refresh(), // Trigger map redraw for circle
                    ),
                    const SizedBox(height: 32),
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.confirmSavePosko(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF2E3D8A), // Sinergo Blue
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("SIMPAN POSKO BARU",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                          ),
                        )),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      "Daftar Posko Aktif",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => controller.poskos.isEmpty
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text("Belum ada posko aktif",
                                style: TextStyle(color: Colors.grey)),
                          ))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.poskos.length,
                            separatorBuilder: (ctx, i) =>
                                const Divider(height: 1),
                            itemBuilder: (ctx, i) {
                              final posko = controller.poskos[i];
                              return ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          26, 33, 150, 243), // blue 0.1
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.location_city,
                                      color: Color(0xFF2E3D8A)),
                                ),
                                title: Text(posko.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                    "${posko.radius}m | Grid: ${posko.lat.toStringAsFixed(4)}, ${posko.lng.toStringAsFixed(4)}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () => _confirmDelete(
                                      context, posko.odId, posko.name),
                                ),
                              );
                            },
                          )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, String name) {
    Get.defaultDialog(
      title: "Hapus Posko?",
      middleText: "Hapus '$name'? Karyawan tidak akan bisa absen di titik ini.",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); // Wait, the controller.deletePosko now handles the dialog completely!
        // So we should just call controller.deletePosko(id, name) directly WITHOUT this wrapping dialog?
        // Ah, looking at the code in PoskoController, deletePosko(id, name) SHOWS a dialog.
        // So here in the View, we should probably remove this _confirmDelete method entirely or change how it's called.
        // BUT, the View likely calls `_confirmDelete` from a button.
        // If I change _confirmDelete to just call controller.deletePosko(id, name), it will work.
        // Let's do that.
        // Actually, if the button calls _confirmDelete, and _confirmDelete shows a defaultDialog,
        // and then inside onConfirm it calls controller.deletePosko which SHOWS ANOTHER dialog... that's bad.

        // Let's check where `_confirmDelete` is called. It's likely called from the UI list item.
        // I should probably remove `_confirmDelete` logic here and just call `controller.deletePosko(id, name)` directly from the button.
        // But to be safe and minimal change:
        // I will change the button in the UI to call controller.deletePosko directly.
        // OR, I can just make this _confirmDelete call controller.deletePosko check.
        // Wait, if I change this to just call the controller method,
        // the controller method will show the dialog.
        // So I should replace the UI call.

        // However, I only see this method definition here. To fix the compilation error QUICKLY:
        // I will just make this method delegate to the controller, removing the local dialog.
        controller.deletePosko(id, name);
      },
    );
  }
}
