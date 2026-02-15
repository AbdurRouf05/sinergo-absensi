import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/modules/admin/controllers/admin_controller.dart';
import 'package:attendance_fusion/app/theme/app_colors.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/data/models/user_model.dart';

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
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                  label: const Text("SIMPAN PERUBAHAN"),
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
  void _saveChanges() {
    // 1. Save office changes
    controller.updateEmployeeOffices(
      widget.employee.odId,
      selectedOfficeIds,
    );

    // 2. Save shift change (if changed)
    if (selectedShiftOdId != null &&
        selectedShiftOdId != widget.employee.shiftOdId) {
      controller.updateEmployeeShift(
        widget.employee.odId,
        selectedShiftOdId!,
      );
    }
  }

  // ============ HEADER INFO ============
  Widget _buildInfoSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary,
          child: Text(
            (widget.employee.name.isNotEmpty)
                ? widget.employee.name[0].toUpperCase()
                : 'U',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.employee.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text(widget.employee.email,
                  style: TextStyle(color: Colors.grey[600])),
              Text("Dept: ${widget.employee.department ?? '-'}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ),
      ],
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
        ),
        child: const Text("Belum ada data shift tersedia.",
            style: TextStyle(color: Colors.grey)),
      );
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        hintText: "Pilih Shift Kerja",
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
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              Text(
                "${shift.startTime} - ${shift.endTime}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }).toList(),
      selectedItemBuilder: (context) {
        return shifts.map((ShiftLocal shift) {
          return Text(
            "${shift.name} (${shift.startTime} - ${shift.endTime})",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          );
        }).toList();
      },
      onChanged: (String? newValue) {
        setState(() {
          selectedShiftOdId = newValue;
        });
      },
    );
  }

  // ============ OFFICE CHECKBOX ============
  Widget _buildOfficeCheckbox(OfficeLocationLocal office) {
    final isSelected = selectedOfficeIds.contains(office.odId);
    return CheckboxListTile(
      title: Text(office.name),
      subtitle: Text("Radius: ${office.radius}m"),
      value: isSelected,
      activeColor: AppColors.primary,
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            selectedOfficeIds.add(office.odId);
          } else {
            selectedOfficeIds.remove(office.odId);
          }
        });
      },
    );
  }

  // ============ RESET DEVICE SECTION ============
  Widget _buildResetDeviceSection() {
    final devId = widget.employee.registeredDeviceId ?? '';
    final hasDevice = devId.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text("Zona Berbahaya",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  )),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasDevice
                ? "Device ID: ${devId.length > 16 ? '${devId.substring(0, 16)}...' : devId}"
                : "Tidak ada device yang terdaftar.",
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: hasDevice
                  ? () => controller.resetDevice(
                      widget.employee.odId, widget.employee.name)
                  : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(
                    color: hasDevice ? Colors.red : Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.phonelink_erase),
              label: const Text("HAPUS DEVICE BINDING"),
            ),
          ),
        ],
      ),
    );
  }
}
