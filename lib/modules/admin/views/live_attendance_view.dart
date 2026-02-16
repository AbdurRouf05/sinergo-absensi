import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sinergo_app/modules/admin/controllers/live_attendance_controller.dart';

class LiveAttendanceView extends StatelessWidget {
  const LiveAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate Controller here or ensure it's put in Binding
    // Using Get.put here for simplicity if not in binding yet, but best practice is Binding.
    // We will assume Binding handles it, but for safety in sub-widget usage without named route:
    final controller = Get.put(LiveAttendanceController());

    return Column(
      children: [
        // 1. Stats Row
        Obx(() => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                      'Hadir', controller.stats['hadir'] ?? 0, Colors.green),
                  _buildStatCard(
                      'Telat', controller.stats['telat'] ?? 0, Colors.orange),
                  _buildStatCard(
                      'Izin', controller.stats['izin'] ?? 0, Colors.blue),
                  _buildStatCard(
                      (controller.stats['belumAbsen'] ?? 0) > 0
                          ? 'Belum'
                          : 'Alpa',
                      (controller.stats['belumAbsen'] ?? 0) > 0
                          ? (controller.stats['belumAbsen'] ?? 0)
                          : (controller.stats['alpa'] ?? 0),
                      (controller.stats['belumAbsen'] ?? 0) > 0
                          ? Colors.amber
                          : Colors.red),
                ],
              ),
            )),

        // 2. List Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text("Live Monitoring",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Spacer(),
              Icon(Icons.live_tv, size: 16, color: Colors.redAccent),
              SizedBox(width: 4),
              Text("Real-time",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),

        // 3. Main List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.monitorList.isEmpty) {
              return RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView(
                  children: const [
                    SizedBox(height: 100),
                    Center(child: Text("Belum ada data karyawan.")),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: controller.refreshData,
              child: ListView.builder(
                itemCount: controller.monitorList.length,
                itemBuilder: (context, index) {
                  final item = controller.monitorList[index];
                  return _buildUserTile(item);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Container(
      width: 70, // Fixed width for alignment
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(count.toString(),
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildUserTile(AttendanceMonitorItem item) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (item.status) {
      case LiveStatus.hadir:
        statusColor = Colors.green;
        statusText = "HADIR";
        statusIcon = Icons.check_circle;
        break;
      case LiveStatus.telat:
        statusColor = Colors.orange;
        statusText = "TELAT";
        statusIcon = Icons.warning_amber_rounded;
        break;
      case LiveStatus.izin:
        statusColor = Colors.blue;
        statusText = "IZIN";
        statusIcon = Icons.info_outline;
        break;
      case LiveStatus.alpa:
        statusColor = Colors.red;
        statusText = "ALPA";
        statusIcon = Icons.cancel_outlined;
        break;
      case LiveStatus.belumAbsen:
        statusColor = Colors.amber;
        statusText = "BELUM";
        statusIcon = Icons.schedule;
        break;
    }

    // Time Display
    String timeInfo = "-";
    if (item.attendance != null) {
      final date = item.attendance!.checkInTime.toLocal();
      timeInfo = DateFormat('HH:mm').format(date);
    } else if (item.status == LiveStatus.izin) {
      timeInfo = "Cuti";
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0, // Flat premium look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[200],
          backgroundImage:
              item.photoUrl != null ? NetworkImage(item.photoUrl!) : null,
          child: item.photoUrl == null
              ? Text(
                  (item.user.name.isNotEmpty)
                      ? item.user.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(fontWeight: FontWeight.bold))
              : null,
        ),
        title: Text(
          item.user.name.isNotEmpty ? item.user.name : 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(statusText,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Text(timeInfo,
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        trailing: Icon(statusIcon, color: statusColor),
        onTap: () {
          // Future: Open User Detail or Map View
        },
      ),
    );
  }
}
