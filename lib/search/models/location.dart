import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart '
    as weather_repository;

part 'location.g.dart';

@JsonSerializable()
class Location extends Equatable {
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const Location({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  factory Location.fromRepository(weather_repository.Location location) {
    return Location(
      city: location.city,
      country: location.country,
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  static final empty = Location(
    city: "",
    country: "",
    latitude: 0.0,
    longitude: 0.0,
  );

  @override
  List<Object?> get props => [
        city,
        country,
        latitude,
        longitude,
      ];

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  Location copyWith({
    String? city,
    String? country,
    double? latitude,
    double? longitude,
  }) {
    return Location(
      city: city ?? this.city,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
