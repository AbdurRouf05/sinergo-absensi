import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class CheckoutCameraManager extends GetxController {
  final Logger _logger = Logger();
  final Rx<File?> capturedPhoto = Rx<File?>(null);
  final RxBool isCapturingPhoto = false.obs;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> capturePhoto() async {
    if (isCapturingPhoto.value) return;
    isCapturingPhoto.value = true;

    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 80,
      );

      if (photo != null) {
        capturedPhoto.value = File(photo.path);
        _logger.i('Checkout photo captured: ${photo.path}');
      }
    } catch (e) {
      _logger.e('Failed to capture photo', error: e);
    } finally {
      isCapturingPhoto.value = false;
    }
  }

  void clearPhoto() {
    capturedPhoto.value = null;
  }
}
