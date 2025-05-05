import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_daily.g.dart';

/// expose a domain-specific weather model.
/// This model will contain only data relevant to our business cases
/// in other words it should be completely decoupled from the API client and raw data format.
@JsonSerializable()
class WeatherDaily extends Equatable {
  final List<String> time;
  final List<double> temperatureMin;
  final List<double> temperatureMax;
  final List<double> windSpeed;
  final List<String> windDirection;
  final List<WeatherCondition> condition;

  factory WeatherDaily.fromJson(Map<String, dynamic> json) =>
      _$WeatherDailyFromJson(json);

  const WeatherDaily({
    required this.time,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.windSpeed,
    required this.windDirection,
    required this.condition,
  });

  @override
  List<Object?> get props => [
        time,
        temperatureMax,
        temperatureMin,
        windSpeed,
        windDirection,
        condition,
      ];
}
