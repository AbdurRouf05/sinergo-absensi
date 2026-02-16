import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';
import 'profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.grey200,
              child: Icon(Icons.person, size: 50, color: AppColors.grey500),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ganti Foto Avatar melalui Admin",
              style: TextStyle(color: AppColors.grey500, fontSize: 12),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap",
                hintText: "Masukkan nama lengkap Anda",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Pastikan nama sesuai dengan identitas resmi untuk keperluan absensi.",
              style: TextStyle(color: AppColors.warning, fontSize: 12),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.updateProfileName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
