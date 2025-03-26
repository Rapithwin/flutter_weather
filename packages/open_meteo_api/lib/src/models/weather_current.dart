import 'package:json_annotation/json_annotation.dart';
part 'weather.g.dart';

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

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  WeatherCurrent({
    required this.temperature,
    required this.weatherCode,
    required this.isDay,
    required this.windSpeed,
  });
}
