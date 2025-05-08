import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart' hide WeatherDaily;

part 'daily.g.dart';

@JsonSerializable()
class WeatherDaily extends Equatable {
  final List<String> time;
  final List<double> temperatureMin;
  final List<double> temperatureMax;
  final List<double> windSpeed;
  final List<String> windDirection;
  final List<WeatherCondition> condition;

  const WeatherDaily({
    required this.time,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.windSpeed,
    required this.windDirection,
    required this.condition,
  });

  factory WeatherDaily.fromJson(Map<String, dynamic> json) =>
      _$WeatherDailyFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDailyToJson(this);

  static final empty = WeatherDaily(
    time: [],
    temperatureMin: [],
    temperatureMax: [],
    windSpeed: [],
    windDirection: [],
    condition: [],
  );

  WeatherDaily copyWith({
    final List<String>? time,
    final List<double>? temperatureMin,
    final List<double>? temperatureMax,
    final List<double>? windSpeed,
    final List<String>? windDirection,
    final List<WeatherCondition>? condition,
  }) {
    return WeatherDaily(
      time: time ?? this.time,
      temperatureMin: temperatureMin ?? this.temperatureMin,
      temperatureMax: temperatureMax ?? this.temperatureMax,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      condition: condition ?? this.condition,
    );
  }

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
