import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:attendance_fusion/data/models/attendance_model.dart';
import 'package:attendance_fusion/modules/admin/controllers/admin_controller.dart';

class OvertimeRequestCard extends StatelessWidget {
  final AttendanceLocal item;
  final AdminController controller;

  const OvertimeRequestCard({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              item.userName ?? "Karyawan",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('dd MMM yyyy, HH:mm').format(item.checkInTime),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "PENDING",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Catatan Lembur:",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(item.overtimeNote ?? "Tidak ada catatan",
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      "${item.overtimeMinutes ?? 0} Menit",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _showRejectDialog(context),
                  icon: const Icon(Icons.close, color: Colors.red),
                  label:
                      const Text("Tolak", style: TextStyle(color: Colors.red)),
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: TextButton.icon(
                  onPressed: () => controller.approveOvertime(item.odId!),
                  icon: const Icon(Icons.check, color: Colors.green),
                  label: const Text("Setujui",
                      style: TextStyle(color: Colors.green)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Tolak Lembur?",
      middleText: "Klaim lembur ini akan ditolak. Lanjutkan?",
      textConfirm: "Ya, Tolak",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.rejectOvertime(item.odId!);
      },
    );
  }
}
