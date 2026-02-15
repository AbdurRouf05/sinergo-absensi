import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/modules/admin/controllers/admin_controller.dart';

class AdminEmployeeController extends GetxController {
  final IIsarService _isarService = Get.find<IIsarService>();
  final IAuthService _authService = Get.find<IAuthService>();

  // State
  final RxBool isLoading = false.obs;
  final RxList<OfficeLocationLocal> availableOffices =
      <OfficeLocationLocal>[].obs;
  final RxList<ShiftLocal> availableShifts = <ShiftLocal>[].obs;

  // Form Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nipController =
      TextEditingController(); // Using NIP as ID/Username helper if needed, or just Name
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Selections
  final Rx<OfficeLocationLocal?> selectedOffice =
      Rx<OfficeLocationLocal?>(null);
  final Rx<ShiftLocal?> selectedShift = Rx<ShiftLocal?>(null);
  final Rx<UserRole> selectedRole = UserRole.employee.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    try {
      isLoading.value = true;
      // Fetch from Isar (cached data)
      // Fetch from Isar (cached data) and deduplicate
      final offices = await _isarService.getActiveOfficeLocations();
      final shifts = await _isarService.getAllShifts();

      // Deduplicate by ID just in case
      final uniqueOffices = {for (var o in offices) o.odId: o}.values.toList();
      final uniqueShifts = {for (var s in shifts) s.odId: s}.values.toList();

      availableOffices.assignAll(uniqueOffices);
      availableShifts.assignAll(uniqueShifts);

      if (availableOffices.isNotEmpty && selectedOffice.value == null) {
        selectedOffice.value = availableOffices.first;
      }
      if (availableShifts.isNotEmpty && selectedShift.value == null) {
        selectedShift.value = availableShifts.first;
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data form: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createEmployee() async {
    if (!_validateInput()) return;

    try {
      isLoading.value = true;
      final body = <String, dynamic>{
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "emailVisibility": true,
        "password": passwordController.text,
        "passwordConfirm": passwordController.text,
        "role": selectedRole.value.name, // 'employee', 'admin', 'hr'
        "office_id": [selectedOffice.value!.odId], // Multiple Relation
        "shift": selectedShift.value!.odId,
        "department": "-", // Default
        // "verified": true, // REMOVED: Causes 400 Error on Create
      };

      // Create in PocketBase
      // Note: This requires the logged-in user to be an Admin
      await _authService.pb.collection('users').create(body: body);

      Get.snackbar("Sukses", "Karyawan berhasil ditambahkan",
          backgroundColor: Colors.green, colorText: Colors.white);

      // Refresh Admin List
      if (Get.isRegistered<AdminController>()) {
        Get.find<AdminController>().refreshEmployees();
      }

      Get.back(); // Close form
    } on ClientException catch (e) {
      debugPrint("PB ClientException: ${e.response}");
      var msg = e.originalError?.toString() ??
          e.response['message']?.toString() ??
          e.toString();

      // Handle data validation errors
      if (e.response['data'] is Map) {
        final data = e.response['data'] as Map;
        if (data.isNotEmpty) {
          // e.g. "email": {"code": "validation_invalid_email", "message": "Must be valid email"}
          final firstKey = data.keys.first;
          final errDetail = data[firstKey];
          if (errDetail is Map && errDetail['message'] != null) {
            msg += " ($firstKey: ${errDetail['message']})";
          }
        }
      }

      Get.snackbar("Gagal", "Error PocketBase: $msg",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5));
    } catch (e) {
      debugPrint("General Create Employee Error: $e");
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInput() {
    if (nameController.text.length < 3) {
      Get.snackbar("Error", "Nama minimal 3 karakter",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar("Error", "Email tidak valid",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (passwordController.text.length < 8) {
      Get.snackbar("Error", "Password minimal 8 karakter",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (selectedOffice.value == null) {
      Get.snackbar("Error", "Pilih Kantor",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (selectedShift.value == null) {
      Get.snackbar("Error", "Pilih Shift",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    nameController.dispose();
    nipController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
