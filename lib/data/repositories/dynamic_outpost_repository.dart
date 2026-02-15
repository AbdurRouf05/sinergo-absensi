import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:attendance_fusion/data/models/dynamic_outpost_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';
import 'package:attendance_fusion/services/auth_service.dart';

abstract class IDynamicOutpostRepository {
  Future<int> broadcastOutpost(double lat, double lng, String name,
      {Duration duration = const Duration(hours: 4)});
  Future<List<DynamicOutpostLocal>> getActiveOutposts();
  Future<void> deactivateOutpost(int id);
}

class DynamicOutpostRepository implements IDynamicOutpostRepository {
  final Logger _logger = Logger();
  final IIsarService _isarService = Get.find<IIsarService>();
  final IAuthService _authService = Get.find<IAuthService>();

  @override
  Future<int> broadcastOutpost(double lat, double lng, String name,
      {Duration duration = const Duration(hours: 4)}) async {
    try {
      final user = _authService.currentUser.value;
      if (user == null) throw Exception('User not authenticated');

      final outpost = DynamicOutpostLocal()
        ..name = name
        ..lat = lat
        ..lng = lng
        ..radius = 50.0 // Default radius for dynamic
        ..createdBy = user.odId
        ..createdAt = DateTime.now()
        ..expirationTime = DateTime.now().add(duration)
        ..isActive = true;

      final id = await _isarService.saveDynamicOutpost(outpost);
      _logger.i('Dynamic Outpost broadcasted: $name at $lat, $lng');

      // TODO: Sync to PocketBase in Phase 5

      return id;
    } catch (e) {
      _logger.e('Failed to broadcast dynamic outpost', error: e);
      rethrow;
    }
  }

  @override
  Future<List<DynamicOutpostLocal>> getActiveOutposts() async {
    return await _isarService.getActiveDynamicOutposts();
  }

  @override
  Future<void> deactivateOutpost(int id) async {
    await _isarService.deactivateOutpost(id);
  }
}
