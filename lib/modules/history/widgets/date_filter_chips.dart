import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../history_controller.dart';

class DateFilterChips extends GetView<HistoryController> {
  const DateFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildChip(DateFilterType.thisMonth, 'Bulan Ini'),
          const SizedBox(width: 8),
          _buildChip(DateFilterType.thisWeek, 'Minggu Ini'),
          const SizedBox(width: 8),
          _buildChip(DateFilterType.today, 'Hari Ini'),
          const SizedBox(width: 8),
          _buildCustomDateChip(),
        ],
      ),
    );
  }

  Widget _buildChip(DateFilterType type, String label) {
    return Obx(() {
      final isSelected = controller.filterType.value == type;
      return FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => controller.filterType.value = type,
        backgroundColor: AppColors.bgLight,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.grey600,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.grey300,
          ),
        ),
        checkmarkColor: AppColors.primary,
      );
    });
  }

  Widget _buildCustomDateChip() {
    return Obx(() {
      final isSelected = controller.filterType.value == DateFilterType.custom;
      return ActionChip(
        avatar: Icon(
          Icons.calendar_today,
          size: 16,
          color: isSelected ? AppColors.primary : AppColors.grey600,
        ),
        label: const Text('Pilih Tanggal'),
        backgroundColor: AppColors.bgLight,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.grey600,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.grey300,
          ),
        ),
        onPressed: () async {
          final result = await showDateRangePicker(
            context: Get.context!,
            firstDate: DateTime(2024),
            lastDate: DateTime.now(),
            initialDateRange: DateTimeRange(
              start: controller.filterStartDate.value ?? DateTime.now(),
              end: controller.filterEndDate.value ?? DateTime.now(),
            ),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    onSurface: AppColors.grey900,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (result != null) {
            controller.updateDateRange(result.start, result.end);
          }
        },
      );
    });
  }
}
