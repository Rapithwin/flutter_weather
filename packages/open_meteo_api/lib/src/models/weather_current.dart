import 'package:json_annotation/json_annotation.dart';
part 'weather_current.g.dart';

@JsonSerializable()

/// [WeatherCurrent] model containing all the current weather info returnted by
/// the API.
class WeatherCurrent {
  final double temperature;
  // specifies that the JSON key corresponding to the weatherCode
  // property in the Dart model is "weathercode".
  @JsonKey(name: "weathercode")
  final double weatherCode;

  @JsonKey(name: "is_day")
  final int isDay;

  @JsonKey(name: "windspeed")
  final double windSpeed;

  @JsonKey(name: "apparent_temperature")
  final double feelsLike;

  @JsonKey(name: "wind_direction_10m")
  final double windDirection;

  @JsonKey(name: "relative_humidity_2m")
  final int humidity;

  final double visibility;

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) =>
      _$WeatherCurrentFromJson(json);

  WeatherCurrent({
    required this.temperature,
    required this.weatherCode,
    required this.isDay,
    required this.windSpeed,
    required this.feelsLike,
    required this.humidity,
    required this.visibility,
    required this.windDirection,
  });
}
