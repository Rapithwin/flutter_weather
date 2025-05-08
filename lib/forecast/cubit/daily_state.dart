part of 'daily_cubit.dart';

enum ForecastStatus { initial, loading, success, failure }

extension ForecastStatusX on ForecastStatus {
  bool get isInitial => this == ForecastStatus.initial;
  bool get isLoading => this == ForecastStatus.loading;
  bool get isSuccess => this == ForecastStatus.success;
  bool get isFailure => this == ForecastStatus.failure;
}

sealed class DailyState extends Equatable {
  DailyState({
    this.status = ForecastStatus.initial,
    WeatherDaily? daily,
    this.units = Units.metric,
  }) : daily = daily ?? WeatherDaily.empty;

  final ForecastStatus status;
  final WeatherDaily daily;
  final Units units;

  @override
  List<Object> get props => [];
}
