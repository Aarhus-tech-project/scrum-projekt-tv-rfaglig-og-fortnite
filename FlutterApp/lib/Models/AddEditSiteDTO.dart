class AddEditSiteDTO {
  String? id;
  String name = "";
  String address = "";
  bool isPublic = true;

  List<AddEditRoomDTO> rooms = [];
  List<AddEditUserSiteDTO> users = [];
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
}

class AddEditUserSiteDTO {
  String email = "";
  UserRole role = UserRole.Normal;

  AddEditUserSiteDTO({
    this.email = "",
    this.role = UserRole.Normal,
  });
}

enum UserRole
{
  Normal,
  Admin
}
