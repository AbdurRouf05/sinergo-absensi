import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'analytics_controller.dart';
// import 'widgets/analytics_summary_cards.dart'; // Removed
import 'widgets/analytics_recap_list.dart';
import 'widgets/analytics_date_header.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AnalyticsController>()) {
      Get.put(AnalyticsController());
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text("Dashboard Analitik")),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildContent()),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: controller.refreshDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Removed Today Section as per request
            AnalyticsDateHeader(controller: controller),
            const SizedBox(height: 12),
            AnalyticsRecapList(
              recapValues: controller.periodicRecap,
              onExport: _showExportChoices,
            ),
          ],
        ),
      ),
    );
  }

  void _showExportChoices() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Pilih Format Export",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.grey),
              title: const Text("Salin ke Clipboard"),
              onTap: () {
                Get.back();
                controller.copyRecapToClipboard();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("Export PDF (Laporan Resmi)"),
              onTap: () {
                Get.back();
                controller.exportPdf();
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text("Export CSV (Excel)"),
              onTap: () {
                Get.back();
                controller.exportCsv();
              },
            ),
          ],
        ),
      ),
    );
  }
}
