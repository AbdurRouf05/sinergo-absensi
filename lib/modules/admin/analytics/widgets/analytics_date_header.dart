import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../analytics_controller.dart';

class AnalyticsDateHeader extends StatelessWidget {
  final AnalyticsController controller;

  const AnalyticsDateHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateInfo(),
          OutlinedButton.icon(
            onPressed: () => _showRangePicker(context),
            icon: const Icon(Icons.date_range, size: 18),
            label: const Text("Pilih Rentang"),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo() {
    return Obx(() {
      final start = DateFormat('dd MMM').format(controller.startDate.value);
      final end = DateFormat('dd MMM yyyy').format(controller.endDate.value);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rentang Rekap",
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          Text("$start - $end",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      );
    });
  }

  Future<void> _showRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: controller.startDate.value,
        end: controller.endDate.value,
      ),
    );
    if (picked != null) {
      controller.loadPeriodicRecap(picked.start, picked.end);
    }
  }
}
