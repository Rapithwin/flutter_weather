import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;
import 'package:weather_repository/weather_repository.dart' hide WeatherHourly;

part 'weather_hourly.g.dart';

@JsonSerializable()
class WeatherHourly extends Equatable {
  final List<String> time;
  final List<bool> isDay;
  final List<WeatherCondition> condition;
  final List<double> temperature;

  const WeatherHourly({
    required this.time,
    required this.isDay,
    required this.condition,
    required this.temperature,
  });

  factory WeatherHourly.fromJson(Map<String, dynamic> json) =>
      _$WeatherHourlyFromJson(json);

  factory WeatherHourly.fromRepository(
      weather_repository.WeatherHourly hourly) {
    return WeatherHourly(
      time: hourly.time,
      isDay: hourly.isDay,
      condition: hourly.condition,
      temperature: hourly.temperature,
    );
  }

  static final empty = WeatherHourly(
    time: [],
    isDay: [],
    condition: [],
    temperature: [],
  );

  Map<String, dynamic> toJson() => _$WeatherHourlyToJson(this);

  WeatherHourly copyWith({
    List<WeatherCondition>? condition,
    List<String>? time,
    List<bool>? isDay,
    List<double>? temperature,
  }) {
    return WeatherHourly(
      time: time ?? this.time,
      isDay: isDay ?? this.isDay,
      condition: condition ?? this.condition,
      temperature: temperature ?? this.temperature,
    );
  }

  @override
  List<Object?> get props => [
        time,
        isDay,
        condition,
        temperature,
      ];
}
