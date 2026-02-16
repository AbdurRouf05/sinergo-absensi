import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_controller.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/data/models/user_model.dart';

class EmployeeDetailView extends StatefulWidget {
  final UserLocal employee;
  const EmployeeDetailView({super.key, required this.employee});

  @override
  State<EmployeeDetailView> createState() => _EmployeeDetailViewState();
}

class _EmployeeDetailViewState extends State<EmployeeDetailView> {
  final AdminController controller = Get.find<AdminController>();
  late List<String> selectedOfficeIds;
  String? selectedShiftOdId;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data
    selectedOfficeIds =
        List<String>.from(widget.employee.allowedOfficeIds ?? []);
    selectedShiftOdId = widget.employee.shiftOdId;
    controller.fetchAllOffices();
    controller.fetchAllShifts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Karyawan")),
      body: Obx(() {
        if (controller.allOffices.isEmpty && controller.allShifts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection(),
              const SizedBox(height: 24),

              // ============ SHIFT SECTION ============
              _buildSectionHeader(
                icon: Icons.schedule,
                title: "Shift Kerja",
                subtitle: "Ubah jadwal shift karyawan ini.",
              ),
              const SizedBox(height: 12),
              _buildShiftDropdown(),
              const SizedBox(height: 32),

              // ============ OFFICE SECTION ============
              _buildSectionHeader(
                icon: Icons.business,
                title: "Akses Kantor (Multi-Office)",
                subtitle:
                    "Pilih kantor mana saja yang boleh diakses karyawan ini.",
              ),
              const SizedBox(height: 12),
              ...controller.allOffices
                  .map((office) => _buildOfficeCheckbox(office)),
              const SizedBox(height: 32),

              // ============ SAVE BUTTON ============
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 2.5),
                    ),
                  ),
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: const Text(
                    "SIMPAN PERUBAHAN",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ============ DANGER ZONE: RESET DEVICE ============
              _buildResetDeviceSection(),
            ],
          ),
        );
      }),
    );
  }

  // ============ SAVE ALL CHANGES ============
  Future<void> _saveChanges() async {
    // 1. Save office changes
    await controller.updateEmployeeOffices(
      widget.employee.odId,
      selectedOfficeIds,
    );

    // 2. Save shift change (if changed)
    if (selectedShiftOdId != null &&
        selectedShiftOdId != widget.employee.shiftOdId) {
      await controller.updateEmployeeShift(
        widget.employee.odId,
        selectedShiftOdId!,
      );
    }

    // Feedback handled by controller snackbars
  }

  // ============ HEADER INFO ============
  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary,
              child: Text(
                (widget.employee.name.isNotEmpty)
                    ? widget.employee.name[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.employee.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(widget.employee.email,
                    style: TextStyle(
                        color: Colors.grey[800], fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Text("Dept: ${widget.employee.department ?? '-'}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ SECTION HEADER ============
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  // ============ SHIFT DROPDOWN ============
  Widget _buildShiftDropdown() {
    final shifts = controller.allShifts;

    if (shifts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black, width: 2.5),
        ),
        child: const Text("Belum ada data shift tersedia.",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          hintText: "Pilih Shift Kerja",
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        isExpanded: true,
        key: ValueKey(selectedShiftOdId),
        initialValue: shifts.any((s) => s.odId == selectedShiftOdId)
            ? selectedShiftOdId
            : null,
        items: shifts.map((ShiftLocal shift) {
          return DropdownMenuItem<String>(
            value: shift.odId,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  shift.name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
                Text(
                  "${shift.startTime} - ${shift.endTime}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                ),
              ],
            ),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return shifts.map((ShiftLocal shift) {
            return Text(
              "${shift.name} (${shift.startTime} - ${shift.endTime})",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              overflow: TextOverflow.ellipsis,
            );
          }).toList();
        },
        onChanged: (String? newValue) {
          setState(() {
            selectedShiftOdId = newValue;
          });
        },
      ),
    );
  }

  // ============ OFFICE CHECKBOX ============
  Widget _buildOfficeCheckbox(OfficeLocationLocal office) {
    final isSelected = selectedOfficeIds.contains(office.odId);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isSelected ? AppColors.primary : Colors.black,
            width: isSelected ? 2.5 : 1.5),
      ),
      child: CheckboxListTile(
        title: Text(office.name,
            style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text("Radius: ${office.radius}m"),
        value: isSelected,
        activeColor: AppColors.primary,
        checkColor: Colors.white,
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              selectedOfficeIds.add(office.odId);
            } else {
              selectedOfficeIds.remove(office.odId);
            }
          });
        },
      ),
    );
  }

  // ============ RESET DEVICE SECTION ============
  Widget _buildResetDeviceSection() {
    final devId = widget.employee.registeredDeviceId ?? '';
    final hasDevice = devId.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.6),
            blurRadius: 0,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppColors.error, size: 24),
              const SizedBox(width: 8),
              Text("ZONA BERBAHAYA",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.error,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hasDevice
                ? "Device ID: ${devId.length > 16 ? '${devId.substring(0, 16)}...' : devId}"
                : "Tidak ada device yang terdaftar.",
            style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: hasDevice
                  ? () => controller.resetDevice(
                      widget.employee.odId, widget.employee.name)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.error,
                elevation: 0,
                side: BorderSide(
                    color: hasDevice ? AppColors.error : Colors.grey[300]!,
                    width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.phonelink_erase),
              label: const Text("HAPUS DEVICE BINDING",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
