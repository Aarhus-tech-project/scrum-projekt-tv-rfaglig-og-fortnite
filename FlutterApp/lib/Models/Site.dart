import 'package:classroom_finder_app/Models/Room.dart';

class Site {
  String id;
  String name;
  double lat;
  double lon;
  double alt;
  String address;
  bool isPublic;
  int roomCount;

  Site({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.alt,
    required this.address,
    required this.isPublic,
    required this.roomCount
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lon: (json['lon'] ?? 0).toDouble(),
      alt: (json['alt'] ?? 0).toDouble(),
      address: json['adresse'] ?? '',
      isPublic: json['isPublic'] ?? false,
      roomCount: (json['roomCount'] ?? 0).toInt()
    );
  }
}
