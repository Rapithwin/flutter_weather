import 'package:bloc/bloc.dart';
import 'package:bloc_weather/forecast/models/daily.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'daily_state.dart';
part 'daily_cubit.g.dart';

class DailyCubit extends Cubit<DailyState> {
  DailyCubit(this._weatherRepository) : super(DailyState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchDaily(
    double? latitude,
    double? longitude,
  ) async {
    if (latitude == null || longitude == null) return;
    emit(state.copyWith(status: ForecastStatus.loading));

    try {
      final weatherDaily = WeatherDaily.fromRepository(
        await _weatherRepository.getForecastDaily(latitude, longitude),
      );

      final units = state.units;

      final temperatureMax = units.isImperial
          ? weatherDaily.temperatureMax.map((e) => e.toFahrenheit()).toList()
          : weatherDaily.temperatureMax;
      final temperatureMin = units.isImperial
          ? weatherDaily.temperatureMin.map((e) => e.toFahrenheit()).toList()
          : weatherDaily.temperatureMin;
      final windSpeed = units.isImperial
          ? weatherDaily.windSpeed.map((e) => e.toMph()).toList()
          : weatherDaily.windSpeed;

      emit(state.copyWith(
        status: ForecastStatus.success,
        units: state.units,
        daily: weatherDaily.copyWith(
          time: weatherDaily.time,
          temperatureMax: temperatureMax,
          temperatureMin: temperatureMin,
          windSpeed: windSpeed,
          windDirection: weatherDaily.windDirection,
          condition: weatherDaily.condition,
        ),
      ));
    } on Exception {
      emit(state.copyWith(
        status: ForecastStatus.failure,
      ));
    }
  }

  Future<void> refreshDaily(double? latitude, double? longitude) async {
    if (!state.status.isSuccess) return;
    if (state.daily == WeatherDaily.empty) return;

    try {
      final weatherDaily = WeatherDaily.fromRepository(
        await _weatherRepository.getForecastDaily(latitude!, longitude!),
      );
      final units = state.units;

      final temperatureMax = units.isImperial
          ? weatherDaily.temperatureMax.map((e) => e.toFahrenheit()).toList()
          : weatherDaily.temperatureMax;
      final temperatureMin = units.isImperial
          ? weatherDaily.temperatureMin.map((e) => e.toFahrenheit()).toList()
          : weatherDaily.temperatureMin;
      final windSpeed = units.isImperial
          ? weatherDaily.windSpeed.map((e) => e.toMph()).toList()
          : weatherDaily.windSpeed;

      emit(state.copyWith(
        status: ForecastStatus.success,
        units: state.units,
        daily: weatherDaily.copyWith(
          time: weatherDaily.time,
          temperatureMax: temperatureMax,
          temperatureMin: temperatureMin,
          windSpeed: windSpeed,
          windDirection: weatherDaily.windDirection,
          condition: weatherDaily.condition,
        ),
      ));
    } on Exception {
      emit(
        state.copyWith(status: ForecastStatus.failure),
      );
    }
  }

  void toggleUnits() {
    final units = state.units.isImperial ? Units.metric : Units.imperial;
    if (!state.status.isSuccess) {
      emit(state.copyWith(units: units));
      return;
    }

    final weatherDaily = state.daily;

    if (weatherDaily != WeatherDaily.empty) {
      final temperatureMax = units.isImperial
          ? weatherDaily.temperatureMax.map((e) => e.toFahrenheit()).toList()
          : weatherDaily.temperatureMax.map((e) => e.toCelsius()).toList();
      final temperatureMin = units.isImperial
          ? weatherDaily.temperatureMin.map((e) => e.toFahrenheit()).toList()
          : weatherDaily.temperatureMin.map((e) => e.toCelsius()).toList();
      final windSpeed = units.isImperial
          ? weatherDaily.windSpeed.map((e) => e.toMph()).toList()
          : weatherDaily.windSpeed.map((e) => e.toKmph()).toList();

      emit(
        state.copyWith(
            units: units,
            daily: weatherDaily.copyWith(
              temperatureMax: temperatureMax,
              temperatureMin: temperatureMin,
              windSpeed: windSpeed,
            )),
      );
    }
  }
}

extension TemperatureConversion on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;

  /// Convert kilometers per hour to miles per hour
  double toKmph() => this * 1.609;

  /// Convert milers per hour to kilometers per hour
  double toMph() => this * 0.621;
}
