import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:isar/isar.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/data/repositories/interfaces/i_admin_repository.dart';
import 'package:attendance_fusion/data/models/office_location_model.dart';
import 'package:attendance_fusion/data/models/user_model.dart'; // Added
import 'package:attendance_fusion/data/models/shift_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

import '../logic/admin_dashboard_manager.dart';
import '../logic/admin_employee_manager.dart';

import 'package:attendance_fusion/data/models/attendance_model.dart';

class AdminController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();
  final IAdminRepository _adminRepo = Get.find<IAdminRepository>();
  final Logger _logger = Logger();

  late final AdminDashboardManager _dashboardManager;
  late final AdminEmployeeManager _employeeManager;

  // State
  var isLoading = false.obs;

  // Dashboard Stats
  var totalEmployees = 0.obs;
  var presentToday = 0.obs;
  var leaveToday = 0.obs;
  var pendingLeaves = 0.obs;
  var pendingOvertimeCount = 0.obs;
  var alpaToday = 0.obs;
  var absentEmployees = <String>[].obs;

  // Data Lists
  var employees = <UserLocal>[].obs; // Changed to UserLocal
  var pendingOvertimeList = <AttendanceLocal>[].obs;
  var allOffices = <OfficeLocationLocal>[].obs;
  var allShifts = <ShiftLocal>[].obs; // NEW: For shift picker in detail view

  @override
  void onInit() {
    super.onInit();
    _dashboardManager = AdminDashboardManager();
    _employeeManager = AdminEmployeeManager();

    fetchDashboardStats();
    fetchEmployees();
    fetchPendingOvertime();
    fetchAllShifts(); // NEW: Preload shifts
  }

  // ============ DASHBOARD LOGIC ============
  Future<void> fetchDashboardStats({bool forceRefresh = false}) async {
    try {
      final stats = await _dashboardManager.fetchStats();
      totalEmployees.value = stats['totalEmployees'] ?? 0;
      presentToday.value = stats['presentToday'] ?? 0;
      leaveToday.value = stats['leaveToday'] ?? 0;
      pendingLeaves.value = stats['pendingLeaves'] ?? 0;
      pendingOvertimeCount.value = stats['pendingOvertime'] ?? 0;
      alpaToday.value = stats['alpaToday'] ?? 0;
      absentEmployees.assignAll(List<String>.from(stats['absentEmployees']));
    } catch (e) {
      _logger.e("Error fetching dashboard stats", error: e);
    }
  }

  Future<void> refreshDashboard() async {
    isLoading.value = true;
    await fetchDashboardStats(forceRefresh: true);
    isLoading.value = false;
  }

  // ============ EMPLOYEE MANAGER LOGIC ============
  Future<void> fetchEmployees() async {
    try {
      isLoading.value = true;
      final result = await _employeeManager.fetchEmployees();
      employees.assignAll(result);
    } catch (e) {
      _logger.e("Fetch Employees Error", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshEmployees() async {
    try {
      isLoading.value = true;
      final result = await _employeeManager.refreshEmployees();
      employees.assignAll(result);
      _showSnackbar("Sukses", "Data karyawan berhasil diperbarui");
    } catch (e) {
      _showSnackbar("Error", "Gagal memperbarui: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetDevice(String userId, String userName) async {
    if (userId == _authService.currentUser.value?.odId) {
      _showSnackbar("Error", "Tidak dapat mereset akun sendiri!",
          isError: true);
      return;
    }

    Get.defaultDialog(
        title: "Reset Device ID?",
        middleText: "User '$userName' akan bisa login di HP baru. Lanjutkan?",
        textConfirm: "Ya, Reset",
        textCancel: "Batal",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm: () async {
          Get.back();
          try {
            Get.dialog(const Center(child: CircularProgressIndicator()),
                barrierDismissible: false);

            await _employeeManager.resetDeviceId(userId);

            if (Get.isDialogOpen ?? false) Get.back();
            _showSnackbar("Sukses", "Device ID berhasil di-reset");
            fetchEmployees();
          } catch (e) {
            if (Get.isDialogOpen ?? false) Get.back();
            _showSnackbar("Error", "Gagal reset: $e", isError: true);
          }
        });
  }

  // ============ BROADCAST & MULTI-OFFICE ============
  Future<void> fetchAllOffices() async {
    try {
      final isarService = Get.find<IIsarService>();
      // UNRELATED TYPE FIX: user.id is String, result.data['id'] is likely String too from PocketBase records
      // But Isar IDs are ints? No, OfficeLocationLocal uses Id id = Isar.autoIncrement; (User defined?)
      // Let's check OfficeLocationModel. If id is int, we can't compare String.

      // FIX 2: findAll()
      final offices = await isarService.isar
          .collection<OfficeLocationLocal>()
          .where()
          .findAll();
      allOffices.assignAll(offices);
    } catch (e) {
      _logger.e("Fetch All Offices Error", error: e);
    }
  }

  Future<void> sendBroadcast(
      String title, String message, String target) async {
    try {
      isLoading.value = true;
      await _adminRepo.broadcastAnnouncement(
          title: title, message: message, target: target);
      _showSnackbar("Sukses", "Pengumuman berhasil dikirim ke $target");
      Get.back();
    } catch (e) {
      _showSnackbar("Error", "Gagal mengirim: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmployeeOffices(
      String userId, List<String> allowedIds) async {
    try {
      isLoading.value = true;
      await _adminRepo.updateEmployeeAllowedOffices(userId, allowedIds);
      _showSnackbar("Sukses", "Akses kantor berhasil diperbarui");
      fetchEmployees();
    } catch (e) {
      _showSnackbar("Error", "Gagal memperbarui: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ============ SHIFT MANAGEMENT ============
  Future<void> fetchAllShifts() async {
    try {
      final isarService = Get.find<IIsarService>();
      final shifts = await isarService.getAllShifts();
      // Deduplicate by odId
      final unique = {for (var s in shifts) s.odId: s}.values.toList();
      allShifts.assignAll(unique);
    } catch (e) {
      _logger.e("Fetch Shifts Error", error: e);
    }
  }

  Future<void> updateEmployeeShift(String userId, String shiftOdId) async {
    try {
      isLoading.value = true;
      await _authService.pb.collection('users').update(userId, body: {
        'shift': shiftOdId,
      });
      _showSnackbar("Sukses", "Shift karyawan berhasil diubah");
      fetchEmployees(); // Refresh
    } catch (e) {
      _showSnackbar("Error", "Gagal mengubah shift: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message,
      {bool isError = false, Duration? duration}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  // ============ OVERTIME REVIEW (PHASE 7) ============
  Future<void> fetchPendingOvertime() async {
    try {
      isLoading.value = true;
      final result = await _adminRepo.getAttendancesByStatus('pendingReview');
      pendingOvertimeList.assignAll(result);
      pendingOvertimeCount.value = result.length;
    } catch (e) {
      _logger.e("Fetch Pending Overtime Error", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveOvertime(String id) async {
    try {
      isLoading.value = true;
      // PHASE 6.4: Set proper approval flags
      await _adminRepo.updateAttendanceStatus(id, 'present', extraBody: {
        'is_overtime_approved': true,
        'is_ganas_approved': true, // Also approve Ganas if applicable
      });
      _showSnackbar("Sukses", "Lembur/Tugas Luar berhasil disetujui");
      fetchPendingOvertime();
      fetchDashboardStats();
    } catch (e) {
      _showSnackbar("Error", "Gagal menyetujui: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectOvertime(String id) async {
    try {
      isLoading.value = true;
      // PHASE 6.4: Clear overtime flags and zero duration on rejection
      await _adminRepo.updateAttendanceStatus(id, 'present', extraBody: {
        'is_overtime': false,
        'is_overtime_approved': false,
        'is_ganas_approved': false,
        'overtime_duration': 0,
      });
      _showSnackbar("Info", "Lembur/Tugas Luar berhasil ditolak");
      fetchPendingOvertime();
      fetchDashboardStats();
    } catch (e) {
      _showSnackbar("Error", "Gagal menolak: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
