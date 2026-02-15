import 'package:isar/isar.dart';
import 'package:attendance_fusion/data/models/user_model.dart';
import 'package:attendance_fusion/services/isar_service.dart';

class UserLocalRepository {
  final IsarService _isarService;

  UserLocalRepository(this._isarService);

  Isar get _isar => _isarService.isar;

  /// Save or update user
  Future<int> saveUser(UserLocal user) async {
    // 1. READ (Outside Transaction)
    final existing =
        await _isar.userLocals.filter().odIdEqualTo(user.odId).findFirst();

    if (existing != null) {
      user.id = existing.id; // Reuse ID for Update
    } else if (user.email.isNotEmpty) {
      // Fallback: Check Email uniqueness
      final existingEmail =
          await _isar.userLocals.filter().emailEqualTo(user.email).findFirst();
      if (existingEmail != null) {
        user.id = existingEmail.id;
      }
    }

    // 2. WRITE (Fast)
    return await _isar.writeTxn(() async {
      return await _isar.userLocals.put(user);
    });
  }

  /// Save or update multiple users
  Future<void> saveUsers(List<UserLocal> users) async {
    if (users.isEmpty) return;

    // 1. Deduplicate input by OD_ID (Take latest)
    // Prevents "Unique index violated" if input list has duplicates
    final uniqueMap = <String, UserLocal>{};
    for (var u in users) {
      uniqueMap[u.odId] = u;
    }
    final usersToSave = uniqueMap.values.toList();

    // 2. Batch Read ALL local users to build lookup map
    // Avoids 'anyOf' query limit issues and N+1 lookups
    final allLocalUsers = await _isar.userLocals.where().findAll();

    final odIdMap = {for (var u in allLocalUsers) u.odId: u.id};
    final emailMap = {for (var u in allLocalUsers) u.email: u.id};

    // 3. Match IDs
    for (var user in usersToSave) {
      if (odIdMap.containsKey(user.odId)) {
        user.id = odIdMap[user.odId]!;
      } else if (user.email.isNotEmpty && emailMap.containsKey(user.email)) {
        // Fallback: If OD_ID changed but email match (Unlikely but safe)
        user.id = emailMap[user.email]!;
      }
    }

    // 4. Batch Write
    await _isar.writeTxn(() async {
      await _isar.userLocals.putAll(usersToSave);
    });
  }

  /// Get user by PocketBase ID
  Future<UserLocal?> getUserByOdId(String odId) async {
    return await _isar.userLocals.filter().odIdEqualTo(odId).findFirst();
  }

  /// Get user by email
  Future<UserLocal?> getUserByEmail(String email) async {
    return await _isar.userLocals.filter().emailEqualTo(email).findFirst();
  }

  /// Get current logged-in user (first user in DB for single-user app)
  Future<UserLocal?> getCurrentUser() async {
    return await _isar.userLocals.where().findFirst();
  }

  /// Delete all users (logout)
  Future<void> clearUsers() async {
    await _isar.writeTxn(() async {
      await _isar.userLocals.clear();
    });
  }
}
