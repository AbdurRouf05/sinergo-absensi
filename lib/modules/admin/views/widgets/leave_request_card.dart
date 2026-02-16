import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sinergo_app/modules/admin/controllers/leave_approval_controller.dart';
import 'package:sinergo_app/data/models/leave_request_model.dart';
import 'package:sinergo_app/data/models/user_model.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequestLocal item;
  final UserLocal? user;
  final LeaveApprovalController controller;
  final bool showActions;

  const LeaveRequestCard({
    super.key,
    required this.item,
    this.user,
    required this.controller,
    required this.showActions,
  });

  @override
  Widget build(BuildContext context) {
    // Extract Employee Name - Prioritize expanded userName from server
    String empName = item.userName ?? user?.name ?? "User: ${item.userId}";

    final type = item.type ?? '-';
    final reason = item.reason ?? '-';
    final rejectionReason = item.rejectionReason;
    final start = item.startDate ?? DateTime.now();
    final end = item.endDate ?? DateTime.now();
    final fmt = DateFormat('dd MMM');
    final odId = item.odId ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(empName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        type == 'sakit' ? Colors.orange[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(type.toString().toUpperCase(),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("${fmt.format(start)} - ${fmt.format(end)}",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(reason,
                style: TextStyle(
                    color: Colors.grey[600], fontStyle: FontStyle.italic)),

            // Rejection Reason
            if (rejectionReason != null && rejectionReason.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red[100]!),
                ),
                child: Text("Alasan: $rejectionReason",
                    style: TextStyle(color: Colors.red[800], fontSize: 12)),
              ),

            // Attachment Preview
            if (item.attachmentUrl != null) ...[
              const SizedBox(height: 12),
              const Text("Bukti Lampiran:",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // Zoom Dialog
                  Get.dialog(
                    Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.zero,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InteractiveViewer(
                            child: CachedNetworkImage(
                              imageUrl: item.attachmentUrl!,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                  size: 64),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            right: 20,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 30),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.attachmentUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image,
                              color: Colors.grey[400], size: 32),
                          const SizedBox(height: 4),
                          const Text("Gagal memuat",
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFF757575))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            if (showActions) ...[
              const Divider(height: 24),
              Obx(() {
                final isSubmitting = controller.actionLoading[odId] ?? false;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: isSubmitting
                          ? null
                          : () => _showRejectDialog(controller, item),
                      style:
                          OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text("Tolak"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () => controller.approveLeave(
                              odId, item.userId ?? '', item.startDate),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text("Setujui"),
                    ),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(
      LeaveApprovalController controller, LeaveRequestLocal item) {
    final reasonController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Tolak Izin"),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: "Alasan Penolakan"),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar("Error", "Alasan wajib diisi");
                return;
              }
              Get.back(); // Close first
              controller.rejectLeave(item.odId ?? '', item.userId ?? '',
                  reasonController.text.trim(), item.startDate);
            },
            child: const Text("Tolak"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
