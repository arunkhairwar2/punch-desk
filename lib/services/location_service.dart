import 'dart:math';
import '../models/office_config.dart';

class LocationService {
  final Random _random = Random();

  /// Generate random coordinates near the office.
  /// ~70% of the time within radius, ~30% outside for testing.
  ({double latitude, double longitude}) getMockLocation() {
    final config = OfficeConfig.defaultConfig;

    // Randomly decide: 70% chance inside radius, 30% outside
    final isInside = _random.nextDouble() < 0.7;

    // 1 degree ≈ 111,320 meters at the equator
    final maxOffsetDegrees = isInside
        ? config.allowedRadiusMeters / 111320 * 0.8 // stay well within
        : config.allowedRadiusMeters / 111320 * 2.5; // clearly outside

    final latOffset =
        (_random.nextDouble() * 2 - 1) * maxOffsetDegrees;
    final lngOffset =
        (_random.nextDouble() * 2 - 1) * maxOffsetDegrees;

    return (
      latitude: config.officeLat + latOffset,
      longitude: config.officeLng + lngOffset,
    );
  }

  /// Haversine formula to calculate distance between two points in meters.
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000.0; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  /// Check if the given location is within the office's allowed radius.
  bool isWithinOfficeRadius(double lat, double lng) {
    final config = OfficeConfig.defaultConfig;
    final distance = calculateDistance(
      config.officeLat,
      config.officeLng,
      lat,
      lng,
    );
    return distance <= config.allowedRadiusMeters;
  }
}
