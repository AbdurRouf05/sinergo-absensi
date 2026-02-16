import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_employee_controller.dart';

class AddEmployeeView extends GetView<AdminEmployeeController> {
  const AddEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller if not already
    Get.put(AdminEmployeeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Karyawan"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Identitas"),
                const SizedBox(height: 8),
                _buildTextField(
                  label: "Nama Lengkap",
                  controller: controller.nameController,
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: "Email (Login)",
                  controller: controller.emailController,
                  icon: Icons.email,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: "Password Default",
                  controller: controller.passwordController,
                  icon: Icons.lock,
                  isPassword: true,
                  hint: "Minimal 8 karakter",
                ),
                const SizedBox(height: 24),
                _buildSectionHeader("Penugasan"),
                const SizedBox(height: 8),
                Obx(() => _buildOfficeDropdown()),
                const SizedBox(height: 12),
                Obx(() => _buildShiftDropdown()),
                const SizedBox(height: 12),
                Obx(() => _buildRoleDropdown()),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controller.createEmployee,
                    child: const Text("SIMPAN KARYAWAN",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          // Loading Overlay
          Obx(() => controller.isLoading.value
              ? Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildOfficeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Kantor Utama",
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      // Fix: Ensure value exists in items
      initialValue: controller.availableOffices
              .any((o) => o.odId == controller.selectedOffice.value?.odId)
          ? controller.selectedOffice.value?.odId
          : null,
      items: controller.availableOffices.map((office) {
        return DropdownMenuItem(
          value: office.odId,
          child: Text(office.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (val) {
        final selected =
            controller.availableOffices.firstWhereOrNull((o) => o.odId == val);
        controller.selectedOffice.value = selected;
      },
      validator: (val) => val == null ? "Wajib dipilih" : null,
    );
  }

  Widget _buildShiftDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Shift Kerja",
        prefixIcon: const Icon(Icons.access_time),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      // Fix: Ensure value exists in items
      initialValue: controller.availableShifts
              .any((s) => s.odId == controller.selectedShift.value?.odId)
          ? controller.selectedShift.value?.odId
          : null,
      items: controller.availableShifts.map((shift) {
        return DropdownMenuItem(
          value: shift.odId, // Use ODID (String)
          child: Text("${shift.name} (${shift.startTime}-${shift.endTime})",
              overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (val) {
        final selected =
            controller.availableShifts.firstWhereOrNull((s) => s.odId == val);
        controller.selectedShift.value = selected;
      },
      validator: (val) => val == null ? "Wajib dipilih" : null,
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<UserRole>(
      decoration: InputDecoration(
        labelText: "Role Akses",
        prefixIcon: const Icon(Icons.security),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      initialValue: controller.selectedRole.value,
      items: UserRole.values.map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(role.displayName),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) controller.selectedRole.value = val;
      },
    );
  }
}
