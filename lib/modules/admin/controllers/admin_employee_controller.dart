import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_controller.dart';

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

  // GOLDEN CODE: DO NOT MODIFY WITHOUT PERMISSION
  // -------------------------------------------------------------------------
  Future<void> createEmployee() async {
    // 1. Validate with Dialogs
    if (!_validateInput()) return;

    try {
      isLoading.value = true;

      // 2. Prepare Data
      final body = <String, dynamic>{
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "emailVisibility": true,
        "password": passwordController.text,
        "passwordConfirm": passwordController.text,
        "role": selectedRole.value.name,
        "office_id": [selectedOffice.value!.odId], // Multiple Relation
        "allowed_offices": [selectedOffice.value!.odId], // Legacy Compatibility
        "shift": selectedShift.value!.odId,
        "department": "-",
        // "verified": true, // REMOVED: PocketBase blocks setting this on create
      };

      // 3. Create in PocketBase
      await _authService.pb.collection('users').create(body: body);

      // 4. Success Dialog & Clear Form
      Get.dialog(
        AlertDialog(
          title: const Text("Berhasil"),
          content:
              Text("Karyawan '${nameController.text}' berhasil ditambahkan."),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Get.back(); // Close Dialog
                _clearForm(); // Clear form for next entry

                // Refresh Admin List in background
                if (Get.isRegistered<AdminController>()) {
                  Get.find<AdminController>().fetchEmployees();
                }
              },
              child: const Text("Oke", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } on ClientException catch (e) {
      debugPrint("PB ClientException: ${e.response}");
      var msg = e.originalError?.toString() ??
          e.response['message']?.toString() ??
          e.toString();

      // Handle data validation errors
      if (e.response['data'] is Map) {
        final data = e.response['data'] as Map;
        if (data.isNotEmpty) {
          final firstKey = data.keys.first;
          final errDetail = data[firstKey];
          if (errDetail is Map && errDetail['message'] != null) {
            msg += " ($firstKey: ${errDetail['message']})";
          }
        }
      }

      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: Text("Error PocketBase: $msg"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint("General Create Employee Error: $e");
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text("Terjadi kesalahan: $e"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    // Reset selections to defaults if available, or keep last selection?
    // User said "cukup kosongkan biasa", usually means text fields.
    // Keeping office/shift might be helpful for bulk entry, but let's safe reset.
    // Actually, widespread practice for "Add Another" is keep Dropdowns, clear Text.
    // Let's clear Text only as it's less annoying.
  }

  bool _validateInput() {
    String? errorMsg;
    if (nameController.text.length < 3) {
      errorMsg = "Nama minimal 3 karakter";
    } else if (!GetUtils.isEmail(emailController.text)) {
      errorMsg = "Email tidak valid";
    } else if (passwordController.text.length < 8) {
      errorMsg = "Password minimal 8 karakter";
    } else if (selectedOffice.value == null) {
      errorMsg = "Pilih Kantor";
    } else if (selectedShift.value == null) {
      errorMsg = "Pilih Shift";
    }

    if (errorMsg != null) {
      Get.dialog(
        AlertDialog(
          title: const Text("Data Tidak Valid"),
          content: Text(errorMsg),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }
  // -------------------------------------------------------------------------

  @override
  void onClose() {
    nameController.dispose();
    nipController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
