import 'package:pocketbase/pocketbase.dart';
import 'package:logger/logger.dart';
import 'package:attendance_fusion/core/errors/app_exceptions.dart';

class AuthProvider {
  final PocketBase _pb;
  final Logger _logger = Logger();

  AuthProvider(this._pb);

  PocketBase get pb => _pb;

  Future<RecordAuth> login(String email, String password) async {
    try {
      return await _pb.collection('users').authWithPassword(
            email,
            password,
            expand: 'shift,office_id',
          );
    } on ClientException catch (e) {
      _logger.e('PocketBase auth failed', error: e);
      throw AuthException(
        _mapPocketBaseError(e),
        code: e.statusCode.toString(),
        originalError: e,
      );
    }
  }

  Future<void> bindDevice(String userId, String deviceId) async {
    try {
      await _pb
          .collection('users')
          .update(userId, body: {'registered_device_id': deviceId});
    } catch (e) {
      _logger.e('Failed to bind device', error: e);
      throw AuthException('Gagal mendaftarkan perangkat', originalError: e);
    }
  }

  Future<bool> refreshAuth() async {
    try {
      if (!_pb.authStore.isValid) return false;
      await _pb.collection('users').authRefresh(expand: 'shift,office_id');
      return true;
    } catch (e) {
      _logger.e('Token refresh failed', error: e);
      return false;
    }
  }

  void clearAuth() {
    _pb.authStore.clear();
  }

  String _mapPocketBaseError(ClientException e) {
    if (e.statusCode == 400) {
      return 'Email atau password salah';
    } else if (e.statusCode == 0) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
    } else {
      return 'Terjadi kesalahan: ${e.response['message'] ?? e.toString()}';
    }
  }
}
