import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/services/auth_service.dart';

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

  // GOLDEN CODE: DO NOT MODIFY WITHOUT PERMISSION
  // -------------------------------------------------------------------------
  Future<void> sendBroadcast() async {
    final title = titleController.text.trim();
    final message = messageController.text.trim();
    final target = selectedTarget.value;

    if (title.isEmpty || message.isEmpty) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: const Text("Judul dan Pesan wajib diisi"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
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
        Get.dialog(
          AlertDialog(
            title: const Text("Error"),
            content: const Text("Tidak ada user target ditemukan"),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Tutup"),
              ),
            ],
          ),
        );
        return;
      }

      // PERSONAL COPY STRATEGY: Create ONE record PER user
      final pb = _authService.pb;
      final adminId = _authService.currentUser.value?.id;

      // Use Future.forEach to avoid overwhelming server if array is huge,
      // but map + wait is fine for now < 100 users.
      final futures = targetIds.map((uid) {
        return pb.collection('notifications').create(body: {
          'title': title,
          'message': message,
          'user_id': uid, // Single user per record (Relation)
          'type': 'info',
          'is_read': false,
          'created_by': adminId,
        });
      }).toList();

      await Future.wait(futures);

      Get.dialog(
        AlertDialog(
          title: const Text("Berhasil"),
          content:
              Text("Pengumuman berhasil dikirim ke ${targetIds.length} orang."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close Dialog
                Get.back(); // Close Page
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // Reset Form
      titleController.clear();
      messageController.clear();
      selectedTarget.value = 'all';
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: Text("Gagal mengirim: $e"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
  // -------------------------------------------------------------------------
}
