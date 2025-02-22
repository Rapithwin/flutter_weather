import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

/// expose a domain-specific weather model.
/// This model will contain only data relevant to our business cases
/// in other words it should be completely decoupled from the API client and raw data format.
@JsonSerializable()
class Weather extends Equatable {
  final String location;
  final double temperature;
  final WeatherCondition condition;
  final bool isDay;
  final double windSpeed;

  const Weather(
      {required this.location,
      required this.temperature,
      required this.condition,
      required this.isDay,
      required this.windSpeed});

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  @override
  List<Object?> get props => [
        location,
        temperature,
        condition,
        isDay,
        windSpeed,
      ];
}
