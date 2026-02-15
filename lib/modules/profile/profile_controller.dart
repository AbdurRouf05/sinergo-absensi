import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attendance_fusion/app/routes/app_routes.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/repositories/user_repository.dart';
import 'package:attendance_fusion/services/auth_service.dart';

import 'edit_profile_view.dart';
import 'logic/profile_data_manager.dart';
import 'logic/profile_photo_manager.dart';
import 'widgets/change_password_dialog.dart';

class ProfileController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();
  final IUserRepository _userRepository = Get.find<IUserRepository>();

  // Helpers
  late final ProfilePhotoManager _photoManager;
  late final ProfileDataManager _dataManager;

  // State
  Rx<UserLocal?> get user => _authService.currentUser;
  final RxString shiftInfo = 'Loading...'.obs;
  final RxString officeInfo = 'Loading...'.obs;
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _photoManager = ProfilePhotoManager(_userRepository, _authService);
    _dataManager = ProfileDataManager(_authService);

    if (user.value != null) {
      nameController.text = user.value!.name;
    }

    ever(user, (u) {
      if (u != null && nameController.text.isEmpty) {
        nameController.text = u.name;
      }
    });

    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _dataManager.fetchProfileDetails(user.value);
    shiftInfo.value = data['shift'] ?? '-';
    officeInfo.value = data['office'] ?? '-';
  }

  void toEditProfile() {
    if (user.value != null) {
      nameController.text = user.value!.name;
    }
    Get.to(() => const EditProfileView());
  }

  Future<void> updateProfileName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty || newName.length < 3) {
      Get.snackbar("Validasi Gagal", "Nama minimal 3 karakter",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      await _userRepository.updateProfile(newName);
      await _authService.restoreSession();

      Get.back(); // Close loading
      Get.back(); // Close Edit Page
      Get.snackbar("Sukses", "Profil berhasil diperbarui",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back();
      Get.snackbar("Gagal", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  void changePassword() {
    if (user.value == null) return;
    Get.dialog(
      ChangePasswordDialog(
        authService: _authService,
        currentUser: user.value!,
      ),
      barrierDismissible: false,
    );
  }

  Future<void> pickAndUploadAvatar(ImageSource source) async {
    await _photoManager.pickAndUploadAvatar(source);
  }
}
