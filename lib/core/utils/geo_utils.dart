import 'package:geolocator/geolocator.dart';

class GeoUtils {
  /// Calculate distance between two points in meters
  static double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  /// Check if location is within radius
  static bool isWithinRadius(double lat, double lng, double targetLat,
      double targetLng, double radius) {
    final distance = calculateDistance(lat, lng, targetLat, targetLng);
    return distance <= radius;
  }
}
