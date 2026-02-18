class OfficeConfig {
  final double officeLat;
  final double officeLng;
  final double allowedRadiusMeters;

  const OfficeConfig({
    required this.officeLat,
    required this.officeLng,
    required this.allowedRadiusMeters,
  });

  static const OfficeConfig defaultConfig = OfficeConfig(
    officeLat: 28.6139,
    officeLng: 77.2090,
    allowedRadiusMeters: 100,
  );
}
