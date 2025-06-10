class Location {
  final int idDriver;
  final String waktuUpdate;
  final double longitude;
  final double latitude;

  Location({
    required this.idDriver,
    required this.waktuUpdate,
    required this.longitude,
    required this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      idDriver: int.parse(json['id_driver'].toString()),
      waktuUpdate: json['waktu_update'].toString(),
      longitude: double.parse(json['longitude'].toString()),
      latitude: double.parse(json['latitude'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_driver': idDriver,
        'waktu_update': waktuUpdate,
        'longitude': longitude,
        'latitude': latitude,
      };
}
