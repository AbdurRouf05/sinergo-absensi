import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:attendance_fusion/services/auth_service.dart';

class AdminBroadcastController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();

  // State
  var isLoading = false.obs;
  var users = <RecordModel>[].obs;
  var selectedTarget = 'all'.obs; // 'all' or specific user ID

  // Text Controllers
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  @override
  void onClose() {
    titleController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      // Fetch all users for dropdown info
      final result = await _authService.pb.collection('users').getFullList(
            sort: '-created',
          );
      users.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat list karyawan: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendBroadcast() async {
    final title = titleController.text.trim();
    final message = messageController.text.trim();
    final target = selectedTarget.value;

    if (title.isEmpty || message.isEmpty) {
      Get.snackbar("Error", "Judul dan Pesan wajib diisi",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      List<String> targetIds = [];

      if (target == 'all') {
        // Collect ALL user IDs
        targetIds = users.map((u) => u.id).toList();
      } else {
        // Single user target
        targetIds = [target];
      }

      if (targetIds.isEmpty) {
        Get.snackbar("Error", "Tidak ada user target ditemukan",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // PERSONAL COPY STRATEGY: Create ONE record PER user
      // This ensures each user has their own is_read state.
      // If User A reads their copy, User B's copy stays unread.
      final pb = _authService.pb;
      final adminId = _authService.currentUser.value?.id;

      final futures = targetIds.map((uid) {
        return pb.collection('notifications').create(body: {
          'title': title,
          'message': message,
          'user_id': [uid], // Single user per record
          'type': 'info',
          'is_read': false,
          'created_by': adminId,
        });
      }).toList();

      await Future.wait(futures);

      Get.snackbar(
          "Sukses", "Pengumuman berhasil dikirim ke ${targetIds.length} orang",
          backgroundColor: Colors.green, colorText: Colors.white);

      // Reset Form
      titleController.clear();
      messageController.clear();
      selectedTarget.value = 'all';

      // Close page? Optional. User may want to send another.
      // Get.back();
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
