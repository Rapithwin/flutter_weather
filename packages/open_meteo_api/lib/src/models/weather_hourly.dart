import 'package:json_annotation/json_annotation.dart';
part 'weather_hourly.g.dart';

@JsonSerializable()

/// [WeatherHourly] model containing a 24-hour weather forecast information
class WeatherHourly {
  final DateTime time;
  final double temperature;

  @JsonKey(name: "is_day")
  final int isDay;

  @JsonKey(name: "weathercode")
  final int weatherCode;

  factory WeatherHourly.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourlyFromJson(json);

  WeatherHourly({
    required this.time,
    required this.temperature,
    required this.isDay,
    required this.weatherCode,
  });
}
