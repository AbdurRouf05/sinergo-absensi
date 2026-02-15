import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:attendance_fusion/core/constants/app_constants.dart';

class SessionManager {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  Future<void> saveSession(String token, RecordModel record) async {
    await _secureStorage.write(key: AppConstants.authTokenKey, value: token);
    await _secureStorage.write(
      key: AppConstants.userDataKey,
      value: jsonEncode(record.toJson()),
    );
  }

  Future<Map<String, dynamic>?> getSession() async {
    final token = await _secureStorage.read(key: AppConstants.authTokenKey);
    final userData = await _secureStorage.read(key: AppConstants.userDataKey);

    if (token != null && userData != null) {
      return {
        'token': token,
        'user_data': jsonDecode(userData),
      };
    }
    return null;
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: AppConstants.authTokenKey);
    await _secureStorage.delete(key: AppConstants.userDataKey);
  }
}
