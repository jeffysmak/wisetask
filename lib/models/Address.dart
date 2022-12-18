import 'package:equatable/equatable.dart';

class AddressCoordinates extends Equatable {
  late String address;
  late double lat;
  late double lon;
  late String title;

  AddressCoordinates();

  AddressCoordinates.current(this.address, this.lat, this.lon);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['address'] = address;
    map['lat'] = lat;
    map['lon'] = lon;
    map['title'] = title;
    return map;
  }

  AddressCoordinates.fromMap(var map) {
    this.address = map['address'];
    this.lat = map['lat'];
    this.lon = map['lon'];
    this.title = map['title'];
  }

  @override
  String toString() {
    return 'AddressCoordinates{address: $address, lat: $lat, lon: $lon}';
  }

  @override
  List<Object?> get props => [
        address,
        lat,
        lon,
        title,
      ];
}
