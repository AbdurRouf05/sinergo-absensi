import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import 'history_controller.dart';
import 'widgets/history_item.dart';
import 'widgets/date_filter_chips.dart';
import 'widgets/history_empty_state.dart';
import '../home/home_controller.dart' as package_home_controller;

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text(
          "Riwayat Kehadiran",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  try {
                    final homeController =
                        Get.find<package_home_controller.HomeController>();
                    homeController.changeTab(0);
                  } catch (e) {
                    Get.back();
                  }
                },
              ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.black,
            height: 2.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.only(bottom: 8, top: 8),
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

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!controller.isLoading.value &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200 &&
                        controller.hasMoreData.value) {
                      controller.loadHistory(loadMore: true);
                    }
                    return true;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.attendanceRecords.length +
                        (controller.isLoading.value ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == controller.attendanceRecords.length) {
                        return const Center(
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator()));
                      }

                      final record = controller.attendanceRecords[index];
                      return HistoryItem(record: record);
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
