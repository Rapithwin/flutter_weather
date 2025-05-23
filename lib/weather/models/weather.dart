import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

part 'weather.g.dart';

enum Units { metric, imperial }

extension TemperatureUnitsX on Units {
  bool get isMetric => this == Units.metric;
  bool get isImperial => this == Units.imperial;
}

@JsonSerializable()
class Temperature extends Equatable {
  final double value;

  const Temperature({required this.value});

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  Map<String, dynamic> toJson() => _$TemperatureToJson(this);

  @override
  List<Object?> get props => [value];
}

@JsonSerializable()
class Weather extends Equatable {
  final WeatherCondition condition;
  final DateTime lastUpdated;
  final String location;
  final Temperature temperature;
  final bool isDay;
  final double windSpeed;
  final double feelsLike;
  final int humidity;
  final double visibility;
  final String windDirection;

  final double? latitude;
  final double? longitude;

  const Weather({
    required this.condition,
    required this.lastUpdated,
    required this.location,
    required this.temperature,
    required this.isDay,
    required this.windSpeed,
    required this.feelsLike,
    required this.humidity,
    required this.visibility,
    required this.windDirection,
    this.latitude,
    this.longitude,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  factory Weather.fromRepository(weather_repository.Weather weather) {
    return Weather(
      condition: weather.condition,
      lastUpdated: DateTime.now(),
      location: weather.location,
      temperature: Temperature(value: weather.temperature),
      isDay: weather.isDay,
      windSpeed: weather.windSpeed,
      feelsLike: weather.feelsLike,
      humidity: weather.humidity,
      visibility: weather.visibility,
      windDirection: weather.windDirection,
    );
  }

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    location: "--",
    temperature: const Temperature(value: 0),
    isDay: false,
    windSpeed: 0.0,
    feelsLike: 0.0,
    humidity: 0,
    visibility: 0,
    windDirection: "-",
  );

  @override
  List<Object?> get props => [
        location,
        condition,
        lastUpdated,
        temperature,
      ];

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  Weather copyWith({
    WeatherCondition? condition,
    DateTime? lastUpdated,
    String? location,
    Temperature? temperature,
    bool? isDay,
    double? windSpeed,
    double? latitude,
    double? longitude,
    double? feelsLike,
    String? windDirection,
    int? humidity,
    double? visibility,
  }) {
    return Weather(
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      isDay: isDay ?? this.isDay,
      windSpeed: windSpeed ?? this.windSpeed,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      visibility: visibility ?? this.visibility,
      windDirection: windDirection ?? this.windDirection,
    );
  }
}
