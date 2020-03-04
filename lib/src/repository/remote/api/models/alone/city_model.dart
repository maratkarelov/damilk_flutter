class CityModel {
  final int id;
  final String title;

  CityModel(this.id, this.title);

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
        json['id'] as int,
        json['title'] as String
    );
  }

  static List<CityModel> fromListJson(List<dynamic> json) {
    final result = List<CityModel>();
    json.forEach((city) =>
    {
      result.add(CityModel.fromJson(city))
    });

    return result;
  }
}
