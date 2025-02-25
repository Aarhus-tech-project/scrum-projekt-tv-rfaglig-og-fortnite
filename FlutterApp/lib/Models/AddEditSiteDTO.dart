import 'dart:convert';

class AddEditSiteDTO {
  String? id;
  String name;
  String address;
  bool isPrivate;
  List<AddEditRoomDTO> rooms;
  List<AddEditUserSiteDTO> users;

  AddEditSiteDTO({
    this.id,
    this.name = "",
    this.address = "",
    this.isPrivate = false,
    this.rooms = const [],
    this.users = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'isPrivate': isPrivate,
      'rooms': rooms.map((room) => room.toJson()).toList(),
      'users': users.map((user) => user.toJson()).toList(),
    };
  }

  factory AddEditSiteDTO.fromJson(Map<String, dynamic> json) {
    return AddEditSiteDTO(
      id: json['id'],
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      isPrivate: json['isPrivate'] ?? false,
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((room) => AddEditRoomDTO.fromJson(room))
              .toList() ??
          [],
      users: (json['users'] as List<dynamic>?)
              ?.map((user) => AddEditUserSiteDTO.fromJson(user))
              .toList() ??
          [],
    );
  }
}

class AddEditRoomDTO {
  String? id;
  String name;
  double lat;
  double lon;
  double alt;
  int level;

  AddEditRoomDTO({
    this.id,
    this.name = "",
    this.lat = 0.0,
    this.lon = 0.0,
    this.alt = 0.0,
    this.level = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lon': lon,
      'alt': alt,
      'level': level,
    };
  }

  factory AddEditRoomDTO.fromJson(Map<String, dynamic> json) {
    return AddEditRoomDTO(
      id: json['id'],
      name: json['name'] ?? "",
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      alt: (json['alt'] ?? 0.0).toDouble(),
      level: json['level'] ?? 0,
    );
  }
}

class AddEditUserSiteDTO {
  String email;
  UserRole role;

  AddEditUserSiteDTO({
    this.email = "",
    this.role = UserRole.normal,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role.index,
    };
  }

  factory AddEditUserSiteDTO.fromJson(Map<String, dynamic> json) {
    return AddEditUserSiteDTO(
      email: json['email'] ?? "",
      role: UserRole.values[json['role'] ?? 0],
    );
  }
}

enum UserRole {
  normal,
  admin
}
