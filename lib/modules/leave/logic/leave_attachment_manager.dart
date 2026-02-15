import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LeaveAttachmentManager {
  final ImagePicker _imagePicker = ImagePicker();

  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString fileName = ''.obs;

  /// Pick image from Camera
  Future<void> pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
      );
      if (image != null) {
        await _processSelectedImage(image);
      }
    } catch (e) {
      _nativeSnackbar('Gagal mengambil foto dari kamera', isError: true);
    }
  }

  /// Pick image from Gallery
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
      );
      if (image != null) {
        await _processSelectedImage(image);
      }
    } catch (e) {
      _nativeSnackbar('Gagal memilih foto dari galeri', isError: true);
    }
  }

  /// Process selected image file
  Future<void> _processSelectedImage(XFile image) async {
    final file = File(image.path);
    if (await file.length() > 5 * 1024 * 1024) {
      _nativeSnackbar('Ukuran file maksimal 5MB', isError: true);
      return;
    }
    selectedFile.value = file;
    fileName.value = image.name;
  }

  /// Show picker dialog (Camera/Gallery)
  void showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Kamera'),
              onTap: () {
                Get.back();
                pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Galeri'),
              onTap: () {
                Get.back();
                pickFromGallery();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void removeFile() {
    selectedFile.value = null;
    fileName.value = '';
  }

  void _nativeSnackbar(String message, {bool isError = false}) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      Get.snackbar(
        isError ? "Error" : "Sukses",
        message,
        backgroundColor: isError ? Colors.red : Colors.green,
        colorText: Colors.white,
      );
    }
  }
}
