/// Custom exceptions for ATTENDANCE FUSION application
library;

/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Authentication related exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalError});
}

/// Device binding exceptions
class DeviceBindingException extends AppException {
  final String? registeredDeviceId;
  final String? currentDeviceId;

  const DeviceBindingException(
    super.message, {
    super.code,
    super.originalError,
    this.registeredDeviceId,
    this.currentDeviceId,
  });

  @override
  String toString() =>
      'DeviceBindingException: $message (registered: $registeredDeviceId, current: $currentDeviceId)';
}

/// Location related exceptions
class LocationException extends AppException {
  const LocationException(super.message, {super.code, super.originalError});
}

/// Mock location detected exception
class MockLocationException extends AppException {
  const MockLocationException([
    super.message = 'Fake GPS detected. Attendance blocked.',
  ]);
}

/// Time manipulation exception
class TimeManipulationException extends AppException {
  final int deviationSeconds;

  const TimeManipulationException(
    super.message, {
    super.code,
    super.originalError,
    this.deviationSeconds = 0,
  });
}

/// Network related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});
}

/// Database related exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.originalError});
}

/// Permission denied exception
class PermissionDeniedException extends AppException {
  final String permission;

  const PermissionDeniedException(
    super.message, {
    super.code,
    super.originalError,
    required this.permission,
  });
}

/// Offline mode exception - operation requires online
class OfflineModeException extends AppException {
  const OfflineModeException([
    super.message = 'This operation requires internet connection.',
  ]);
}

/// Attendance validation exception
class AttendanceValidationException extends AppException {
  final String validationType; // 'wifi', 'gps', 'time', 'device'

  const AttendanceValidationException(
    super.message, {
    super.code,
    super.originalError,
    required this.validationType,
  });
}

/// Server related exceptions
class ServerException extends AppException {
  const ServerException(super.message, {super.code, super.originalError});
}

/// Security violation exceptions
class SecurityException extends AppException {
  const SecurityException(super.message, {super.code, super.originalError});
}
