import 'package:classroom_finder_app/Models/Room.dart';

class Site {
  String name;
  bool isPublic;
  List<Room> rooms;

  Site({
    required this.name,
    required this.isPublic,
    required this.rooms,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      name: json['name'] ?? '',
      isPublic: json['isPublic'] ?? false,
      rooms: (json['rooms'] as List<dynamic>?)?.map((roomJson) => Room.fromJson(roomJson)).toList() ?? [], 
    );
  }
}
