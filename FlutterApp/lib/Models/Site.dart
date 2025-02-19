import 'package:classroom_finder_app/Models/Room.dart';

class Site {
  String name;
  bool isPublic;
  int roomCount;

  Site({
    required this.name,
    required this.isPublic,
    required this.roomCount
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      name: json['name'] ?? '',
      isPublic: json['isPublic'] ?? false,
      roomCount: (json['roomCount'] ?? 0).toInt()
    );
  }
}
