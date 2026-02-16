import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_broadcast_controller.dart';

class AdminBroadcastView extends GetView<AdminBroadcastController> {
  const AdminBroadcastView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kirim Pengumuman")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Target Penerima",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoading.value && controller.users.isEmpty) {
                return const LinearProgressIndicator();
              }

              // Prepare Dropdown Items
              final items = <DropdownMenuItem<String>>[
                const DropdownMenuItem(
                    value: 'all', child: Text("Semua Karyawan")),
              ];

              for (var user in controller.users) {
                final name = user.data['name'] ?? 'Unnamed';
                final email = user.data['email'] ?? '-';
                items.add(DropdownMenuItem(
                  value: user.id,
                  child:
                      Text("$name ($email)", overflow: TextOverflow.ellipsis),
                ));
              }

              return DropdownButtonFormField<String>(
                initialValue: controller.selectedTarget.value,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                items: items,
                onChanged: (val) => controller.selectedTarget.value = val!,
              );
            }),
            const SizedBox(height: 20),
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: "Judul Pengumuman",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.messageController,
              decoration: const InputDecoration(
                labelText: "Pesan",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.sendBroadcast(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Broadcast Color
                      foregroundColor: Colors.white,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("KIRIM PENGUMUMAN"),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
