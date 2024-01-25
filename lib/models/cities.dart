// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Cities {
  final String country;
  final String name;
  final String lat;
  final String lng;

  Cities({
    required this.country,
    required this.name,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'name': name,
      'lat': lat,
      'lng': lng,
    };
  }

  factory Cities.fromMap(Map<String, dynamic> map) {
    return Cities(
      country: map['country'] as String,
      name: map['name'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cities.fromJson(String source) =>
      Cities.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cities(country: $country, name: $name, lat: $lat, lng: $lng)';
  }
}
