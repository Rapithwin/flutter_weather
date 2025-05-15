import 'package:bloc/bloc.dart';
import 'package:bloc_weather/forecast/models/daily.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'daily_state.dart';

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
      emit(state.copyWith(
        status: ForecastStatus.success,
        units: state.units,
        daily: weatherDaily.copyWith(
          time: weatherDaily.time,
          temperatureMax: weatherDaily.temperatureMax,
          temperatureMin: weatherDaily.temperatureMin,
          windSpeed: weatherDaily.windSpeed,
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
      emit(state.copyWith(
        status: ForecastStatus.success,
        units: state.units,
        daily: weatherDaily.copyWith(
          time: weatherDaily.time,
          temperatureMax: weatherDaily.temperatureMax,
          temperatureMin: weatherDaily.temperatureMin,
          windSpeed: weatherDaily.windSpeed,
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
}
