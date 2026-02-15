import 'package:get/get.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/data/repositories/interfaces/i_admin_repository.dart';

class EmployeeListController extends GetxController {
  final IAdminRepository _adminRepository = Get.find<IAdminRepository>();

  final RxList<UserLocal> employees = <UserLocal>[].obs;
  final RxList<UserLocal> filteredEmployees = <UserLocal>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();

    // Listen to search query changes
    debounce(searchQuery, (_) => filterEmployees(),
        time: const Duration(milliseconds: 300));
  }

  Future<void> fetchEmployees() async {
    isLoading.value = true;
    try {
      final result = await _adminRepository.getAllEmployees();
      employees.assignAll(result);
      filterEmployees(); // Initial filter
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data karyawan');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
  }

  void filterEmployees() {
    if (searchQuery.value.isEmpty) {
      filteredEmployees.assignAll(employees);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredEmployees.assignAll(
        employees.where((user) {
          final nameMatch = user.name.toLowerCase().contains(query);
          final emailMatch = user.email.toLowerCase().contains(query);
          final roleMatch = user.role.displayName.toLowerCase().contains(query);
          final deptMatch =
              user.department?.toLowerCase().contains(query) ?? false;
          return nameMatch || emailMatch || roleMatch || deptMatch;
        }).toList(),
      );
    }
  }
}
