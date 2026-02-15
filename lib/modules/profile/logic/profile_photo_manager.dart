import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:attendance_fusion/data/repositories/user_repository.dart';
import 'package:attendance_fusion/services/auth_service.dart';

class ProfilePhotoManager {
  final Logger _logger = Logger();
  final ImagePicker _picker = ImagePicker();
  final IUserRepository _userRepository;
  final IAuthService _authService;

  ProfilePhotoManager(this._userRepository, this._authService);

  Future<void> pickAndUploadAvatar(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      final File originalFile = File(pickedFile.path);
      File fileToUpload = originalFile;

      // Compress
      final targetPath =
          '${originalFile.parent.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        originalFile.absolute.path,
        targetPath,
        minWidth: 500,
        minHeight: 500,
        quality: 70,
      );

      if (compressedFile != null) {
        fileToUpload = File(compressedFile.path);
      }

      // Show Loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Upload
      await _userRepository.updateAvatar(fileToUpload);

      // Refresh Session
      await _authService.restoreSession();

      // Cleanup
      if (compressedFile != null) {
        final f = File(compressedFile.path);
        if (await f.exists()) {
          // await f.delete(); // Optional
        }
      }

      Get.back(); // Dismiss loading

      Get.snackbar('Sukses', 'Foto profil berhasil diperbarui',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();

      _logger.e("Avatar Upload Error", error: e);
      Get.snackbar('Gagal', 'Gagal mengupload foto: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
