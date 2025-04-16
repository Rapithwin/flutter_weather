import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_hourly.g.dart';

/// expose a domain-specific weather model.
/// This model will contain only data relevant to our business cases
/// in other words it should be completely decoupled from the API client and raw data format.
@JsonSerializable()
class WeatherHourly extends Equatable {
  final List<DateTime> time;
  final List<double> temperature;
  final List<bool> isDay;
  final List<WeatherCondition> condition;

  const WeatherHourly({
    required this.time,
    required this.temperature,
    required this.isDay,
    required this.condition,
  });

  factory WeatherHourly.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourlyFromJson(json);

  @override
  List<Object?> get props => [
        time,
        temperature,
        isDay,
        condition,
      ];
}
