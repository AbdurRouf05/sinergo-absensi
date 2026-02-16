import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:isar/isar.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/data/repositories/admin_recap_repository.dart';
import 'package:sinergo_app/data/models/office_location_model.dart';
import 'package:sinergo_app/data/models/user_model.dart'; // Added
import 'package:sinergo_app/data/models/shift_model.dart';
import 'package:sinergo_app/services/isar_service.dart';

import '../logic/admin_dashboard_manager.dart';
import '../logic/admin_employee_manager.dart';

import 'package:sinergo_app/data/models/attendance_model.dart';

class AdminController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();
  final AdminRecapRepository _recapRepo = Get.find<AdminRecapRepository>();
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
  var todaysAttendance = <AttendanceLocal>[].obs; // AI Insight Data source

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

      // Populate attendance list for AI
      if (stats['todaysAttendance'] != null) {
        todaysAttendance.assignAll(stats['todaysAttendance']);
      }
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

  // GOLDEN CODE: DO NOT MODIFY WITHOUT PERMISSION
  // -------------------------------------------------------------------------
  Future<void> resetDevice(String userId, String userName) async {
    // Restriction removed per user request: Admin can reset anyone including self.
    /*
    if (userId == _authService.currentUser.value?.odId) {
       // ... code removed ...
      return;
    }
    */

    Get.dialog(
      AlertDialog(
        title: const Text("Reset Device ID?"),
        content:
            Text("User '$userName' akan bisa login di HP baru. Lanjutkan?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back(); // Close Confirm Dialog

              isLoading.value = true;
              try {
                await _employeeManager.resetDeviceId(userId);

                Get.dialog(
                  AlertDialog(
                    title: const Text("Berhasil"),
                    content: const Text("Device ID berhasil di-reset."),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(), child: const Text("OK")),
                    ],
                  ),
                );

                fetchEmployees();
              } catch (e) {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Gagal"),
                    content: Text("Gagal reset: $e"),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Tutup")),
                    ],
                  ),
                );
              } finally {
                isLoading.value = false;
              }
            },
            child:
                const Text("Ya, Reset", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  // -------------------------------------------------------------------------

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

  // ============ BOARDCAST & MULTI-OFFICE (Direct PB Implementation due to Repo split) ============
  // GOLDEN CODE: DO NOT MODIFY WITHOUT PERMISSION
  // -------------------------------------------------------------------------
  Future<void> sendBroadcast(
      String title, String message, String target) async {
    try {
      isLoading.value = true;
      // Direct PocketBase Create (Refactoring Rule: Keep Repos specific to analytics)
      await _authService.pb.collection('notifications').create(body: {
        'title': title,
        'message': message,
        'target_audience': target,
        'created_by': _authService.currentUser.value?.id,
      });

      // _showSnackbar("Sukses", "Pengumuman berhasil dikirim ke $target");
      Get.dialog(
        AlertDialog(
          title: const Text("Berhasil"),
          content: Text("Pengumuman berhasil dikirim ke $target."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close Dialog
                Get.back(); // Close BottomSheet/Page
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      // _showSnackbar("Error", "Gagal mengirim: $e", isError: true);
      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: Text("Gagal mengirim pengumuman: $e"),
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

  // GOLDEN CODE: DO NOT MODIFY WITHOUT PERMISSION
  // -------------------------------------------------------------------------
  Future<void> updateEmployeeShift(String userId, String shiftOdId) async {
    try {
      isLoading.value = true;
      await _authService.pb.collection('users').update(userId, body: {
        'shift': shiftOdId,
      });
      // _showSnackbar("Sukses", "Shift karyawan berhasil diubah");
      Get.dialog(
        AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Shift karyawan berhasil diubah."),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      fetchEmployees(); // Refresh
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: Text("Gagal mengubah shift: $e"),
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

  // GOLDEN CODE: DO NOT MODIFY WITHOUT PERMISSION
  // -------------------------------------------------------------------------
  Future<void> updateEmployeeOffices(
      String userId, List<String> allowedIds) async {
    try {
      isLoading.value = true;
      // FIX: Update 'office_id' (Primary) and 'allowed_offices' (Legacy)
      // PocketBase Relation 'office_id' can be multiple.
      await _authService.pb.collection('users').update(userId, body: {
        'office_id': allowedIds,
        'allowed_offices':
            allowedIds, // Keep for legacy compatibility if needed
      });
      // _showSnackbar("Sukses", "Akses kantor berhasil diperbarui");
      Get.dialog(
        AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Akses kantor berhasil diperbarui."),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      fetchEmployees();
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Gagal"),
          content: Text("Gagal memperbarui: $e"),
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

  // ============ OVERTIME REVIEW (PHASE 7) ============
  Future<void> fetchPendingOvertime() async {
    try {
      isLoading.value = true;
      final result = await _recapRepo.getAttendancesByStatus('pendingReview');
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
      await _authService.pb.collection('attendances').update(id, body: {
        'status': 'present',
        'is_overtime_approved': true,
        'is_ganas_approved': true,
      });
      // Also update local? Sync will handle it.

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
      await _authService.pb.collection('attendances').update(id, body: {
        'status': 'present',
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

  // ============ DEMO MODE GENERATOR (FORCED LOGIC) ============
  // ============ DEMO MODE GENERATOR (FORCED LOGIC) ============
  String generateDemoContext() {
    List<String> reportLines = [];

    // Use existing employees list from this controller
    var empList = employees;

    // FAILSAFE DEMO: Jika list kosong, anggap ada 3 orang ini
    if (empList.isEmpty) {
      return """
- Admin: HADIR (Status: Tepat Waktu 07:00) ✅
- Tes1: SEDANG IZIN/CUTI (Sakit) ℹ️
- Tes2: TERLAMBAT (Masuk jam 09:36) ⚠️
""";
    }

    // LOGIKA SKENARIO (HARDCODED UNTUK DEMO)
    for (var emp in empList) {
      String name = (emp.name ?? "").toLowerCase();

      if (name.contains("admin")) {
        // SKENARIO 1: ADMIN SELALU HADIR
        reportLines.add("- ${emp.name}: HADIR (Status: Tepat Waktu 07:00) ✅");
      } else if (name.contains("tes1")) {
        // SKENARIO 2: TES1 SELALU IZIN
        reportLines.add("- ${emp.name}: SEDANG IZIN/CUTI ℹ️");
      } else if (name.contains("tes2")) {
        // SKENARIO 3: TES2 SELALU TERLAMBAT (FIXED HERE)
        reportLines.add("- ${emp.name}: TERLAMBAT (Masuk jam 09:36) ⚠️");
      } else {
        // Sisa karyawan lain (jika ada) baru cek logic asli atau anggap Alpa
        reportLines.add("- ${emp.name}: ALPA (Belum Absen) ❌");
      }
    }

    return reportLines.join("\n");
  }
}
