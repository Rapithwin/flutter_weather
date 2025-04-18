part of 'weather_cubit.dart';

enum WeatherStatus { initial, loading, success, failure }

extension WeatherStatusX on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

@JsonSerializable()
final class WeatherState extends Equatable {
  WeatherState({
    this.status = WeatherStatus.initial,
    this.units = Units.metric,
    Weather? weather,
    WeatherHourly? hourly,
  })  : weather = weather ?? Weather.empty,
        hourly = hourly ?? WeatherHourly.empty;

  final WeatherStatus status;
  final Weather weather;
  final WeatherHourly hourly;
  final Units units;

  factory WeatherState.fromJson(Map<String, dynamic> json) =>
      _$WeatherStateFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherStateToJson(this);

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    Units? units,
    WeatherHourly? hourly,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      units: units ?? this.units,
      hourly: hourly ?? this.hourly,
    );
  }

  @override
  List<Object> get props => [status, weather, units, hourly];
}
