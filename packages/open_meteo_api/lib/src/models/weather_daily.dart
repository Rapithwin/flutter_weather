import 'package:json_annotation/json_annotation.dart';
part 'weather_daily.g.dart';

@JsonSerializable()

/// [WeatherDaily] model containing a 24-hour weather forecast information
class WeatherDaily {
  final List<String> time;

  @JsonKey(name: "temperature_2m_min")
  final List<double> minTemperature;

  @JsonKey(name: "temperature_2m_max")
  final List<double> maxTemperature;

  @JsonKey(name: "wind_speed_10m_max")
  final List<double> windSpeed;

  @JsonKey(name: "wind_direction_10m_dominant")
  final List<double> windDirection;

  @JsonKey(name: "weathercode")
  final List<int> weatherCode;

  factory WeatherDaily.fromJson(Map<String, dynamic> json) =>
      _$WeatherDailyFromJson(json);

  WeatherDaily({
    required this.time,
    required this.minTemperature,
    required this.maxTemperature,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
  });
}
