class UserModel {
  final int idUser;
  final bool isActivate;
  final String name;
  final String phone;
  final Location location;

  UserModel(this.idUser, this.isActivate, this.name, this.phone, this.location);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        json['idUser'] as int,
        json['isActivate'] as bool,
        json['name'] as String,
        json['phone'] as String,
        Location.fromJson(json['location'] as Map<String, dynamic>));
  }
}

class Location {
  final int idCity;
  final int idRegion;
  final String titleCity;
  final String titleRegion;

  Location(this.idCity, this.idRegion, this.titleCity, this.titleRegion);
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        json['idCity'] as int,
        json['idRegion'] as int,
        json['titleCity'] as String,
        json['titleRegion'] as String);
  }

}
