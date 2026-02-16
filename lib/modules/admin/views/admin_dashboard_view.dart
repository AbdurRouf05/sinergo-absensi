import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_controller.dart';
import 'package:sinergo_app/modules/admin/views/leave_approval_view.dart';
import 'package:sinergo_app/modules/admin/views/employee_manager_view.dart';
import 'package:sinergo_app/modules/admin/views/live_attendance_view.dart';
import 'package:sinergo_app/modules/admin/controllers/live_attendance_controller.dart';
import 'package:sinergo_app/app/theme/app_colors.dart';
import 'package:sinergo_app/modules/admin/analytics/analytics_view.dart';
import 'package:sinergo_app/modules/admin/analytics/analytics_binding.dart';
import 'package:sinergo_app/modules/admin/views/admin_broadcast_view.dart';
import 'package:sinergo_app/modules/admin/controllers/admin_broadcast_controller.dart';
import 'package:sinergo_app/modules/admin/views/posko_view.dart';
import 'package:sinergo_app/modules/admin/controllers/posko_controller.dart';
import 'package:sinergo_app/modules/admin/views/overtime_approval_view.dart';
import 'package:sinergo_app/modules/admin/dashboard/widgets/smart_insight_card.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring Kehadiran"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.bgLight,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchDashboardStats();
          // Also refresh Live controller if it exists
          if (Get.isRegistered<LiveAttendanceController>()) {
            await Get.find<LiveAttendanceController>().loadInitialData();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // FIXED HEADER (Scrollable List below)
              const SizedBox(height: 12),

              // AI INSIGHT CARD (New Feature)
              const SmartInsightCard(),

              const SizedBox(height: 12),

              // LIVE MONITORING SECTION (Takes available space)
              // LIVE MONITORING SECTION
              Container(
                height: 300, // Fixed height for scrollability
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10),
                  ],
                ),
                child: const LiveAttendanceView(),
              ),

              // MENU SECTION (Bottom Sheet style or just below)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quick Actions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => _buildMenuCard(
                          "Persetujuan Izin",
                          "Approve/Reject cuti",
                          Icons.rule,
                          Colors.purple,
                          () => Get.to(() => const LeaveApprovalView()),
                          badgeCount: controller.pendingLeaves.value,
                        )),
                    const SizedBox(height: 12),
                    Obx(() => _buildMenuCard(
                          "Persetujuan Lembur",
                          "Review klaim lembur",
                          Icons.history_toggle_off,
                          Colors.blue,
                          () {
                            controller.fetchPendingOvertime();
                            Get.to(() => const OvertimeApprovalView());
                          },
                          badgeCount: controller.pendingOvertimeCount.value,
                        )),
                    const SizedBox(height: 12),
                    _buildMenuCard("Manajemen Karyawan", "Reset Device ID",
                        Icons.phonelink_erase, Colors.redAccent, () {
                      controller.fetchEmployees();
                      Get.to(() => const EmployeeManagerView());
                    }),
                    const SizedBox(height: 12),
                    _buildMenuCard("Laporan & Analytics", "Rekap Bulanan",
                        Icons.bar_chart, Colors.teal, () {
                      Get.to(() => const AnalyticsView(),
                          binding: AnalyticsBinding());
                    }),
                    const SizedBox(height: 12),
                    _buildMenuCard("Broadcast Pengumuman", "Kirim ke karyawan",
                        Icons.campaign, Colors.orange, () {
                      Get.to(() => const AdminBroadcastView(),
                          binding: BindingsBuilder(() {
                        Get.put(AdminBroadcastController());
                      }));
                    }),
                    const SizedBox(height: 12),
                    _buildMenuCard(
                        "Manajemen Lokasi Kantor",
                        "Tambah/Hapus Kantor Cabang",
                        Icons.settings_input_antenna,
                        Colors.blueAccent, () {
                      Get.to(() => const PoskoView(),
                          binding: BindingsBuilder(() {
                        Get.put(PoskoController());
                      }));
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ), // RefreshIndicator
    ); // Scaffold
  }

  // Helper widgets remain same...
  Widget _buildMenuCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap,
      {int? badgeCount}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        badgeCount > 9 ? "9+" : "$badgeCount",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
