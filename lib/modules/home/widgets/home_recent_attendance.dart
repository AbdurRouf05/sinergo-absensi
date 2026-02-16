import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../history/widgets/history_item.dart';
import '../home_controller.dart';

class HomeRecentAttendance extends GetView<HomeController> {
  const HomeRecentAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey900,
                ),
              ),
              TextButton(
                onPressed: () => controller.changeTab(1),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.historyController.isLoading.value) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ));
            }

            final list =
                controller.historyController.attendanceRecords.take(3).toList();

            if (list.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: const Column(
                  children: [
                    Icon(Icons.history, size: 48, color: AppColors.grey300),
                    SizedBox(height: 8),
                    Text(
                      'Belum ada riwayat absensi',
                      style: TextStyle(color: AppColors.grey500),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = list[index];
                return HistoryItem(record: item);
              },
            );
          }),
        ],
      ),
    );
  }
}
