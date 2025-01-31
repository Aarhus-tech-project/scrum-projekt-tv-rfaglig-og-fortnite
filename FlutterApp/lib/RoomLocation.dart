class RoomLocation {
  String name;
  double latitude;
  double longitude;
  int level;
  double altitude;

  RoomLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.level,
    required this.altitude,
  });

  factory RoomLocation.fromJson(Map<String, dynamic> json) {
    return RoomLocation(
      name: json['classroomName'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      level: (json['level'] ?? 0).toInt(),
      altitude: (json['altitude'] ?? 0.0).toDouble(),
    );
  }
}
