import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/modules/admin/controllers/posko_controller.dart';

class PoskoView extends GetView<PoskoController> {
  const PoskoView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is put if not already
    // Ideally done in binding, but for simplicity:
    // This view expects controller to be available.

    return Scaffold(
      appBar: AppBar(title: const Text("Buat Posko (Titik Absen)")),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Posko / Kegiatan",
                  border: OutlineInputBorder(),
                  hintText: "Contoh: Posko Banjir A",
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.latController,
                      decoration: const InputDecoration(
                        labelText: "Latitude",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.lngController,
                      decoration: const InputDecoration(
                        labelText: "Longitude",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.getCurrentLocation(),
                  icon: const Icon(Icons.my_location),
                  label: const Text("Ambil Lokasi Saat Ini (GPS)"),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.radiusController,
                decoration: const InputDecoration(
                  labelText: "Radius (Meter)",
                  border: OutlineInputBorder(),
                  hintText: "Default: 100",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.createPosko(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("BUAT POSKO SEKARANG"),
                    ),
                  )),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                "Daftar Posko Aktif",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Obx(() => controller.poskos.isEmpty
                  ? const Text("Belum ada posko aktif")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.poskos.length,
                      itemBuilder: (ctx, i) {
                        final posko = controller.poskos[i];
                        return ListTile(
                          leading:
                              const Icon(Icons.pin_drop, color: Colors.blue),
                          title: Text(posko.name),
                          subtitle: Text(
                              "Radius: ${posko.radius}m | Lat: ${posko.lat}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmDelete(context, posko.odId, posko.name),
                          ),
                        );
                      },
                    )),
            ],
          ),
        ),
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
        Get.back();
        controller.deletePosko(id);
      },
    );
  }
}
