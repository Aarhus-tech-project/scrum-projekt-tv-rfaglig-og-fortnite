class RoomLocation {
  String name;
  double latitude;
  double longitude;
  double altitude;
  int level;
  String site;

  RoomLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.level,
    required this.site,
  });

  factory RoomLocation.fromJson(Map<String, dynamic> json) {
    return RoomLocation(
      name: json['name'] ?? '',
      latitude: (json['lat'] ?? 0.0).toDouble(),
      longitude: (json['lon'] ?? 0.0).toDouble(),
      altitude: (json['alt'] ?? 0.0).toDouble(),
      level: (json['level'] ?? 0).toInt(),
      site: json['site'] ?? '',
    );
  }
}
