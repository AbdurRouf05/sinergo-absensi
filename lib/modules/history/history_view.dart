import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import 'history_controller.dart';
import 'widgets/history_item.dart';
import 'widgets/date_filter_chips.dart';
import 'widgets/history_empty_state.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Column(
        children: [
          // Filter Section
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.only(bottom: 8),
            child: const DateFilterChips(),
          ),

          // List Section
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshHistory,
              color: AppColors.primary,
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.attendanceRecords.isEmpty &&
                    !controller.hasError.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.hasError.value &&
                    controller.attendanceRecords.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: AppColors.grey600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.refreshHistory,
                          child: const Text('Coba Lagi'),
                        )
                      ],
                    ),
                  );
                }

                if (controller.attendanceRecords.isEmpty) {
                  return Stack(
                    children: [
                      ListView(), // Ensure RefreshIndicator works even when empty
                      HistoryEmptyState(onRefresh: controller.refreshHistory),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.attendanceRecords.length + 1,
                  itemBuilder: (context, index) {
                    // Pagination loader at bottom
                    if (index == controller.attendanceRecords.length) {
                      return controller.hasMoreData.value
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox(height: 40); // Bottom padding
                    }

                    // Trigger pagination load
                    if (index > controller.attendanceRecords.length - 5 &&
                        controller.hasMoreData.value &&
                        !controller.isLoading.value) {
                      controller.loadHistory(loadMore: true);
                    }

                    final record = controller.attendanceRecords[index];
                    return HistoryItem(record: record);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
