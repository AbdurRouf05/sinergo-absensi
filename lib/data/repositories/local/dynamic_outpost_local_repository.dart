import 'package:isar/isar.dart';
import 'package:attendance_fusion/data/models/dynamic_outpost_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

class DynamicOutpostLocalRepository {
  final IsarService _isarService;

  DynamicOutpostLocalRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  /// Save dynamic outpost
  Future<int> saveDynamicOutpost(DynamicOutpostLocal outpost) async {
    return await _isar.writeTxn(() async {
      return await _isar.dynamicOutpostLocals.put(outpost);
    });
  }

  /// Get active dynamic outposts
  Future<List<DynamicOutpostLocal>> getActiveDynamicOutposts() async {
    final now = DateTime.now();
    return await _isar.dynamicOutpostLocals
        .filter()
        .isActiveEqualTo(true)
        .expirationTimeGreaterThan(now)
        .findAll();
  }

  /// Delete expired outposts
  Future<void> cleanExpiredOutposts() async {
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.dynamicOutpostLocals
          .filter()
          .expirationTimeLessThan(now)
          .deleteAll();
    });
  }

  /// Deactivate an outpost
  Future<void> deactivateOutpost(int id) async {
    await _isar.writeTxn(() async {
      final outpost = await _isar.dynamicOutpostLocals.get(id);
      if (outpost != null) {
        outpost.isActive = false;
        await _isar.dynamicOutpostLocals.put(outpost);
      }
    });
  }
}
