import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../leave_controller.dart';

class LeaveFormView extends GetView<LeaveController> {
  const LeaveFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          const Text(
            "Formulir Pengajuan",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // --- DROPDOWN TIPE ---
          Obx(() => DropdownButtonFormField<String>(
                initialValue: controller.selectedType.value,
                decoration: const InputDecoration(
                  labelText: 'Tipe Izin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['sakit', 'izin', 'cuti']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (v) => controller.selectedType.value = v!,
              )),
          const SizedBox(height: 16),

          // --- DATE PICKER ---
          TextField(
            controller: controller.dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Pilih Tanggal (Mulai - Sampai)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: () => controller.pickDateRange(context),
          ),
          const SizedBox(height: 16),

          // --- ALASAN ---
          TextField(
            onChanged: (v) => controller.reason.value = v,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Alasan Pengajuan',
              hintText: 'Contoh: Demam tinggi / Urusan keluarga',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit_note),
            ),
          ),
          const SizedBox(height: 16),

          // --- UPLOAD FILE ---
          const Text("Lampiran (Wajib untuk Sakit)",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Obx(() => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    if (controller.attachmentManager.selectedFile.value != null)
                      Column(
                        children: [
                          const Icon(Icons.file_present,
                              size: 40, color: Colors.green),
                          Text(
                            controller
                                .attachmentManager.selectedFile.value!.path
                                .split('/')
                                .last,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () => controller
                                .attachmentManager.selectedFile.value = null,
                            child: const Text("Hapus",
                                style: TextStyle(color: Colors.red)),
                          )
                        ],
                      )
                    else
                      Column(
                        children: [
                          const Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: controller
                                .attachmentManager.showImagePickerDialog,
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text("Ambil Foto (Kamera/Galeri)"),
                          ),
                        ],
                      ),
                  ],
                ),
              )),
          const SizedBox(height: 32),

          // --- SUBMIT BUTTON ---
          Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("KIRIM PENGAJUAN",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )),
        ],
      ),
    );
  }
}
