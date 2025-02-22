import 'package:bloc_weather/weather/models/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'weather_state.dart';
part 'weather_cubit.g.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(WeatherState());
  final WeatherRepository _weatherRepository;

  /// Uses the weather repository to try and retrieve a weather
  /// object for the given city
  Future<void> fetchWeather(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(city),
      );
      final units = state.units;
      final temperatureValue = units.isImperial
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          units: units,
          weather: weather.copyWith(
            temperature: Temperature(value: temperatureValue),
          ),
        ),
      );
    } on Exception {
      emit(state.copyWith(
        status: WeatherStatus.failure,
      ));
    }
  }

  /// Retrieves a new weather object using the weather repository
  /// given the current weather state
  Future<void> refreshWeather() async {
    if (!state.status.isSuccess) return;
    if (state.weather == Weather.empty) return;
    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(state.weather.location),
      );
      final units = state.units;
      final temperatureValue = units.isImperial
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          units: units,
          weather: weather.copyWith(
            temperature: Temperature(value: temperatureValue),
          ),
        ),
      );
    } on Exception {
      emit(
        state,
      );
    }
  }

  /// Toggles the state between Celsius and Fahrenheit
  void toggleUnits() {
    final units = state.units.isImperial ? Units.metric : Units.imperial;

    if (!state.status.isSuccess) {
      emit(state.copyWith(units: units));
      return;
    }

    final weather = state.weather;
    if (weather != Weather.empty) {
      final temperature = weather.temperature;
      final temperatureValue = units.isMetric
          ? temperature.value.toCelsius()
          : temperature.value.toFahrenheit();
      emit(
        state.copyWith(
          units: units,
          weather: weather.copyWith(
            temperature: Temperature(value: temperatureValue),
          ),
        ),
      );
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) =>
      WeatherState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WeatherState state) => state.toJson();
}

extension TemperatureConversion on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
  double toCelsius() => (this - 32) * 5 / 9;

  /// Convert kilometers per hour to miles per hour
  double toKmph() => this * 1.609;

  /// Convert milers per hour to kilometers per hour
  double toMph() => this * 0.621;
}
