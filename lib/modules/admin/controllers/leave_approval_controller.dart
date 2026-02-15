import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendance_fusion/data/repositories/interfaces/i_admin_repository.dart';
import 'package:attendance_fusion/data/models/leave_request_model.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:intl/intl.dart';

class LeaveApprovalController extends GetxController {
  final IAdminRepository _adminRepo = Get.find<IAdminRepository>();

  // State
  var isLoading = false.obs;
  var actionLoading = <String, bool>{}.obs;

  // Lists for Tabs
  var pendingList = <LeaveRequestLocal>[].obs;
  var approvedList = <LeaveRequestLocal>[].obs;
  var rejectedList = <LeaveRequestLocal>[].obs;

  // Lazy Loaded Users
  var userMap = <String, UserLocal>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _adminRepo.getLeaveRequestsByStatus('pending'),
        _adminRepo.getLeaveRequestsByStatus('approved'),
        _adminRepo.getLeaveRequestsByStatus('rejected'),
      ]);

      pendingList.assignAll(results[0]);
      approvedList.assignAll(results[1]);
      rejectedList.assignAll(results[2]);

      await fetchUsersForLeaves();
    } catch (e) {
      debugPrint("Error fetching leaves: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUsersForLeaves() async {
    try {
      final users = await _adminRepo.getAllEmployees();
      for (var user in users) {
        userMap[user.odId] = user;
      }
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }
  }

  Future<void> approveLeave(
      String id, String userId, DateTime? startDate) async {
    final dateStr =
        startDate != null ? DateFormat('dd MMM').format(startDate) : '-';
    await _updateStatus(id, userId, 'approved',
        title: 'Izin Disetujui',
        message: 'Pengajuan izin Anda pada tanggal $dateStr telah DISETUJUI.');
  }

  Future<void> rejectLeave(
      String id, String userId, String reason, DateTime? startDate) async {
    final dateStr =
        startDate != null ? DateFormat('dd MMM').format(startDate) : '-';
    await _updateStatus(id, userId, 'rejected',
        rejectionReason: reason,
        title: 'Izin Ditolak',
        message:
            'Maaf, izin Anda pada tanggal $dateStr DITOLAK. Alasan: $reason');
  }

  Future<void> _updateStatus(String id, String userId, String status,
      {String? rejectionReason,
      required String title,
      required String message}) async {
    actionLoading[id] = true;

    try {
      // 1. Update Repository (Now handles Notification too)
      await _adminRepo.updateLeaveStatus(id, status,
          rejectionReason: rejectionReason);

      Get.snackbar("Sukses", "Data berhasil diperbarui",
          backgroundColor: status == 'approved' ? Colors.green : Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

      await fetchAll();
    } catch (e) {
      debugPrint("Update status error: $e");
      Get.defaultDialog(title: "Error", middleText: e.toString());
    } finally {
      actionLoading[id] = false;
    }
  }
}
