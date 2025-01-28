import 'package:json_annotation/json_annotation.dart';
part 'location.g.dart';

@JsonSerializable()
class Location {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
