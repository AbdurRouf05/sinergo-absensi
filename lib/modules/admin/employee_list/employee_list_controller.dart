import 'package:get/get.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:sinergo_app/data/repositories/interfaces/i_admin_repository.dart';

class EmployeeListController extends GetxController {
  final IAdminRepository _adminRepository = Get.find<IAdminRepository>();

  final RxList<UserLocal> employees = <UserLocal>[].obs;
  final RxList<UserLocal> filteredEmployees = <UserLocal>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  // Pagination
  static const int _pageSize = 20;
  final RxBool hasMoreData = true.obs;
  int _currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();

    // Listen to search query changes
    debounce(searchQuery, (_) {
      // Search change resets pagination and fetches from DB
      fetchEmployees(reset: true);
    }, time: const Duration(milliseconds: 300));
  }

  Future<void> fetchEmployees(
      {bool loadMore = false, bool reset = false}) async {
    try {
      if (reset) {
        _currentPage = 0;
        employees.clear();
        hasMoreData.value = true;
        isLoading.value = true;
      } else if (loadMore) {
        if (!hasMoreData.value || isLoading.value) return;
        isLoading.value = true;
      } else {
        // Initial load
        isLoading.value = true;
      }

      final offset = _currentPage * _pageSize;

      // Note: If searching, we might want to search on SERVER side or local?
      // For now, we fetch ALL locally paginated, but filtering is done in memory on the `employees` list.
      // IF we have 1000 employees, fetching all at once is bad.
      // But `filterEmployees` filters the `employees` list.
      // So we are paginating the FETCH from DB.
      // But if we search "Z", and "Z" is on page 10, we won't find it if we only loaded page 1.
      // Ideally, specific search query should query DB.
      // BUT `getAllEmployees` in repo doesn't support search query yet.
      // Given constraints (Phase 5 Polish), let's implement simple pagination.
      // IF search is active, we might need to fetch ALL or search in DB.
      // Let's assume for now:
      // 1. If search query is empty -> Use pagination.
      // 2. If search query is NOT empty -> Search in DB (need to add search support to repo?)
      //    OR just fetch all?
      //    Current implementation fetches ALL userLocals from Isar (which is fastish).
      //    Let's keep it simple: If search is active, we ignore pagination and search locally?
      //    No, that defeats the purpose of optimization.
      //    Let's stick to pagination for the MAIN list.
      //    If user searches, we reset and filter what we have?
      //    No, users expect to search entire DB.
      //    For now, let's implement pagination for the "Browsing" mode.

      final result = await _adminRepository.getAllEmployees(
        limit: _pageSize,
        offset: offset,
        searchQuery: searchQuery.value,
      );

      if (reset || !loadMore) {
        employees.assignAll(result);
      } else {
        employees.addAll(result);
      }

      // Update Pagination State
      if (result.length < _pageSize) {
        hasMoreData.value = false;
      } else {
        _currentPage++;
      }

      // Filter logic is now handled by DB query
      // so unique list is what we have in `employees`
      // We map `filteredEmployees` to `employees` directly or just use employees.
      filteredEmployees.assignAll(employees);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data karyawan');
      // print('Error fetching employees: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshEmployees() async {
    await fetchEmployees(reset: true);
  }

  void onSearch(String query) {
    searchQuery.value = query;
  }

  // Deprecated/Removed: filterEmployees() is no longer needed as we query DB.
  // But we might need it if we want to filter logically? No.
  // We should remove the usage in onInit too.
}
