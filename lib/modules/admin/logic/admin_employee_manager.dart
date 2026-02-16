import 'package:get/get.dart';

import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/services/sync_service.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'package:isar/isar.dart';

class AdminEmployeeManager {
  final IAuthService _authService = Get.find<IAuthService>();
  final IIsarService _isarService = Get.find<IIsarService>();
  final ISyncService _syncService = Get.find<ISyncService>();

  /// Get all employees from Local DB (Offline First)
  Future<List<UserLocal>> fetchEmployees() async {
    return await _isarService.isar.userLocals.where().sortByName().findAll();
  }

  /// Trigger Sync and return updated list
  Future<List<UserLocal>> refreshEmployees() async {
    // Trigger Sync (Background)
    await _syncService.syncMasterData();
    // Re-fetch
    return await fetchEmployees();
  }

  Future<void> resetDeviceId(String userId) async {
    // userId is PocketBase ID (odId)
    await _authService.pb.collection('users').update(userId, body: {
      'registered_device_id': null, // Clear Device ID (Use null to unset)
    });

    // FIX: Update local DB directly instead of full syncMasterData (faster)
    try {
      final isarService = Get.find<IIsarService>();
      final user = await isarService.isar
          .collection<UserLocal>()
          .filter()
          .odIdEqualTo(userId)
          .findFirst();
      if (user != null) {
        await isarService.isar.writeTxn(() async {
          user.registeredDeviceId = '';
          await isarService.isar.collection<UserLocal>().put(user);
        });
      }
    } catch (_) {
      // Fallback: full sync if direct update fails
      await _syncService.syncMasterData();
    }
  }
}
