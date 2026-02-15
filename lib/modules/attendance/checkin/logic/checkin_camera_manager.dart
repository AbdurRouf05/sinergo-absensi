import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class CheckInCameraManager extends GetxController {
  final Logger _logger = Logger();
  final ImagePicker _imagePicker = ImagePicker();

  final Rx<File?> capturedPhoto = Rx<File?>(null);
  final RxBool isCapturingPhoto = false.obs;

  /// Capture photo for attendance (WAJIB per ROADMAP)
  /// Compresses to < 500KB before saving
  Future<void> capturePhoto() async {
    if (isCapturingPhoto.value) return;

    isCapturingPhoto.value = true;

    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );

      if (photo == null) {
        isCapturingPhoto.value = false;
        return;
      }

      // Compress image to < 500KB
      final compressedPath = await _compressImage(photo.path);
      capturedPhoto.value = File(compressedPath);

      _logger.i('Photo captured and compressed: $compressedPath');
    } catch (e) {
      _logger.e('Failed to capture photo', error: e);
      Get.snackbar('Error', 'Gagal mengambil foto.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isCapturingPhoto.value = false;
    }
  }

  /// Compress image to target size < 500KB
  Future<String> _compressImage(String imagePath) async {
    final file = File(imagePath);
    final fileSize = await file.length();

    // If already under 500KB, return as-is
    if (fileSize < 500 * 1024) {
      return imagePath;
    }

    // Compress using flutter_image_compress
    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/attendance_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      imagePath,
      targetPath,
      quality: 70,
      minWidth: 1024,
      minHeight: 1024,
    );

    if (result != null) {
      final compressedSize = await result.length();
      _logger
          .i('Compressed ${fileSize ~/ 1024}KB -> ${compressedSize ~/ 1024}KB');
      return result.path;
    }

    // Fallback to original if compression fails
    _logger.w('Compression failed, using original image');
    return imagePath;
  }

  /// Clear captured photo
  void clearPhoto() {
    capturedPhoto.value = null;
  }
}
