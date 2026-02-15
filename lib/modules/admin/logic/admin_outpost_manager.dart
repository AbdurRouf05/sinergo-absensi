import 'package:get/get.dart';
import 'package:attendance_fusion/core/errors/app_exceptions.dart';
import 'package:attendance_fusion/data/repositories/dynamic_outpost_repository.dart';
import 'package:attendance_fusion/services/auth_service.dart';
import 'package:attendance_fusion/services/location_service.dart';
import 'package:attendance_fusion/services/security_service.dart';

class AdminOutpostManager {
  final IDynamicOutpostRepository _outpostRepo =
      Get.find<IDynamicOutpostRepository>();
  final ILocationService _locationService = Get.find<ILocationService>();
  final ISecurityService _securityService = Get.find<ISecurityService>();
  final IAuthService _authService = Get.find<IAuthService>();

  Future<void> broadcastCurrentLocation() async {
    // 1. Security Check (Anti-Mock)
    final isSafe = await _securityService.performSecurityCheck();
    if (!isSafe) {
      throw const SecurityException('Perangkat tidak aman untuk broadcast.');
    }

    // 2. Get Current GPS
    final pos = await _locationService.getCurrentPosition(forceRefresh: true);
    if (pos == null) throw const LocationException('GPS tidak tersedia.');

    // 3. Broadcast
    final adminName = _authService.currentUser.value?.name ?? 'Admin';
    await _outpostRepo.broadcastOutpost(
      pos.latitude,
      pos.longitude,
      "Titik $adminName",
    );
  }
}
