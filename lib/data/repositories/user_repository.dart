import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:sinergo_app/core/errors/app_exceptions.dart';
import 'package:sinergo_app/services/auth_service.dart';
import 'package:sinergo_app/services/device_service.dart';
import 'package:sinergo_app/services/isar_service.dart';
import 'package:sinergo_app/data/models/user_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Interface for UserRepository to enable clean mocking in tests
abstract class IUserRepository {
  Future<void> updateProfile(String name);
  Future<void> syncUserData();
  Future<void> updateAvatar(File imageFile);
}

/// User Repository - Handles user data operations
class UserRepository implements IUserRepository {
  final Logger _logger = Logger();
  late PocketBase _pb;
  late IIsarService _isarService;
  late IDeviceService _deviceService;

  // Dependency Injection via GetX
  UserRepository() {
    try {
      final authService = Get.find<IAuthService>();
      _pb = authService.pb;
      _isarService = Get.find<IIsarService>();
      _deviceService = Get.find<IDeviceService>();
    } catch (e) {
      _logger.e('Failed to resolve dependencies for UserRepository', error: e);
    }
  }

  /// Update user profile name
  ///
  /// Security:
  /// - Validates android_id matches registered_device_id
  /// - Requires active internet connection
  @override
  Future<void> updateProfile(String name) async {
    _logger.i('Updating profile name to: $name');

    // 1. Get current user
    final user = await _isarService.getCurrentUser();
    if (user == null) {
      throw const AuthException('User tidak ditemukan. Silakan login ulang.');
    }

    // 2. Security Check: Validate Device ID
    await _validateDeviceSecurity(user);

    try {
      // 3. Update to PocketBase
      final body = <String, dynamic>{
        'name': name,
      };

      final record =
          await _pb.collection('users').update(user.odId, body: body);
      _logger.i('Profile updated on server');

      // 4. Update Local DB
      user.name = record.data['name'] ?? name;
      user.updatedAt = DateTime.now();
      await _isarService.saveUser(user);

      _logger.i('Profile updated locally');
    } on ClientException catch (e) {
      _logger.e('Failed to update profile on server', error: e);
      throw ServerException(
          'Gagal mengupdate profil: ${e.response['message'] ?? e.toString()}',
          code: e.statusCode.toString());
    } catch (e) {
      _logger.e('Unknown error during profile update', error: e);
      throw const ServerException('Terjadi kesalahan saat mengupdate profil');
    }
  }

  /// Validate that the current device matches the registered device
  Future<void> _validateDeviceSecurity(UserLocal user) async {
    try {
      // Use core DeviceService to validate binding
      // This ensures consistency with the ID generation logic (Hashed ID)
      await _deviceService.validateDeviceBinding(user.registeredDeviceId);

      _logger.i('Device security check passed');
    } catch (e) {
      if (e is SecurityException) rethrow;
      if (e is DeviceBindingException) {
        throw const SecurityException(
            'Aksi ditolak! Perangkat tidak dikenali. Harap gunakan perangkat yang terdaftar.');
      }
      _logger.e('Device security validation error', error: e);
      // Fail safe: deny if we can't verify
      throw const SecurityException('Gagal memverifikasi keamanan perangkat.');
    }
  }

  /// Force sync user data from server
  @override
  Future<void> syncUserData() async {
    final user = await _isarService.getCurrentUser();
    if (user == null) return;

    try {
      final record = await _pb
          .collection('users')
          .getOne(user.odId, expand: 'assigned_shift,office_id');

      // We need a way to map this back to UserLocal.
      // Ideally AuthService has the mapping logic. Refactoring strictly might require
      // moving mapping logic here or duplicating it.
      // For now, I will manually update key fields to avoid circle dependency or duplication mania.

      // Update Name
      user.name = record.data['name'] ?? user.name;

      // Update Shift Relation
      final expand = record.data['expand'] as Map<String, dynamic>?;
      if (expand != null) {
        // ... implementation of sync if needed,
        // but instructions focused on updateProfile.
        // I'll leave this simple for now.
      }

      await _isarService.saveUser(user);
    } catch (e) {
      _logger.e('Sync user data failed', error: e);
    }
  }

  /// Update user avatar
  @override
  Future<void> updateAvatar(File imageFile) async {
    try {
      final user = await _isarService.getCurrentUser();
      if (user == null) {
        throw const AuthException('User tidak ditemukan. Silakan login ulang.');
      }

      // 1. Validate Device Binding before allowing upload
      await _validateDeviceSecurity(user);

      _logger.i('Uploading avatar: ${imageFile.path}');

      // 2. Prepare File
      final multipartFile = await http.MultipartFile.fromPath(
        'avatar',
        imageFile.path,
        filename: 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // 3. Upload to PocketBase
      final record = await _pb.collection('users').update(
        user.odId,
        files: [multipartFile],
      );
      _logger.i('Avatar updated on server');

      // 4. Update Local DB
      // PocketBase returns the filename, but we construct the full URL for easy display
      if (record.data['avatar'] != null &&
          record.data['avatar'].toString().isNotEmpty) {
        final avatarFilename = record.data['avatar'] as String;
        final avatarUrl = _pb.files.getUrl(record, avatarFilename).toString();

        user.avatarUrl = avatarUrl;
        user.updatedAt = DateTime.now();
        await _isarService.saveUser(user);

        _logger.i('Local avatar URL updated: $avatarUrl');
      }
    } on ClientException catch (e) {
      _logger.e('Failed to update avatar', error: e);
      throw ServerException(
          'Gagal mengupload avatar: ${e.response['message'] ?? e.toString()}');
    } catch (e) {
      _logger.e('Update avatar error', error: e);
      // Re-throw if it's our own exception
      if (e is AppException) rethrow;
      throw ServerException('Terjadi kesalahan saat mengupload avatar: $e');
    }
  }
}
