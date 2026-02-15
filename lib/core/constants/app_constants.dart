/// Application-wide constants for ATTENDANCE FUSION
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Attendance Fusion';
  static const String appVersion = '0.1.0';

  // PocketBase Configuration
  // Using flutter_dotenv to read from .env file
  static String get pocketBaseUrl =>
      dotenv.env['POCKETBASE_URL'] ?? 'http://localhost:8090';
  static String get s3Endpoint => dotenv.env['S3_ENDPOINT'] ?? '';
  static String get s3BucketName => dotenv.env['S3_BUCKET_NAME'] ?? '';

  // Time Constants
  static const int ntpTimeoutSeconds = 5;
  static const int maxTimeDeviationMinutes = 5; // Max allowed time difference
  static const int syncIntervalSeconds = 30;

  // Location Constants
  static const double defaultLocationRadius = 100.0; // meters
  static const int locationTimeoutSeconds = 15;

  // Offline Queue
  static const int maxOfflineQueueSize = 1000;
  static const int syncRetryAttempts = 3;

  // Security
  static const String deviceIdKey = 'device_unique_id';
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // Special Office IDs
  static const String officeIdGanas = 'ganas_mode';
}
