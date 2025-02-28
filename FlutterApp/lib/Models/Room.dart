
class Room {
  String name;
  double latitude;
  double longitude;
  double altitude;
  int level;
  String siteName;

  Room(
      {required this.name,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.level,
      required this.siteName});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'] ?? '',
      latitude: (json['lat'] ?? 0.0).toDouble(),
      longitude: (json['lon'] ?? 0.0).toDouble(),
      altitude: (json['alt'] ?? 0.0).toDouble(),
      level: (json['level'] ?? 0).toInt(),
      siteName: json['siteName'] ?? '',
    );
  }
}
