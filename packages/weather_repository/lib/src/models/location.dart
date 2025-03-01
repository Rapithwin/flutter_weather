import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// expose a domain-specific weather model.
/// This model will contain only data relevant to our business cases
/// in other words it should be completely decoupled from the API client and raw data format.
@JsonSerializable()
class Location extends Equatable {
  final String city;
  final String country;

  const Location({required this.city, required this.country});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [city, country];
}
