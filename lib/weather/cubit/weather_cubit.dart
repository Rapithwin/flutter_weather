import 'package:bloc_weather/weather/models/models.dart';
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
  Future<void> fetchWeather(
    String? city,
    double? latitude,
    double? longitude,
  ) async {
    if (city == null || city.isEmpty || latitude == null || longitude == null) {
      return;
    }

    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final units = state.units;

      // For hourly forecast
      final weatherHourly = WeatherHourly.fromRepository(
        await _weatherRepository.getForecastHourly(latitude, longitude),
      );
      final temperatureHourly = units.isImperial
          ? weatherHourly.temperature.map((e) => e.toFahrenheit()).toList()
          : weatherHourly.temperature;

      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(city, latitude, longitude),
      );
      final temperatureValue = units.isImperial
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;
      final windSpeed =
          units.isImperial ? weather.windSpeed.toMph() : weather.windSpeed;
      final visibility =
          units.isImperial ? weather.visibility.toMph() : weather.visibility;
      final feelsLike = units.isImperial
          ? weather.feelsLike.toFahrenheit()
          : weather.feelsLike;

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          units: units,
          weather: weather.copyWith(
            temperature: Temperature(value: temperatureValue),
            windSpeed: windSpeed,
            latitude: latitude,
            longitude: longitude,
            visibility: visibility,
            feelsLike: feelsLike,
            humidity: weather.humidity,
            windDirection: weather.windDirection,
            condition: weather.condition,
          ),
          hourly: weatherHourly.copyWith(
            temperature: temperatureHourly,
            isDay: weatherHourly.isDay,
            time: weatherHourly.time,
            condition: weatherHourly.condition,
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
  Future<void> refreshWeather(
    double? latitude,
    double? longitude,
  ) async {
    if (!state.status.isSuccess) return;
    if (state.weather == Weather.empty) return;

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.getWeather(
          state.weather.location,
          latitude!,
          longitude!,
        ),
      );
      final units = state.units;

      // For hourly forecast
      final weatherHourly = WeatherHourly.fromRepository(
        await _weatherRepository.getForecastHourly(latitude, longitude),
      );
      final temperatureHourly = units.isImperial
          ? weatherHourly.temperature.map((e) => e.toFahrenheit()).toList()
          : weatherHourly.temperature;

      final temperatureValue = units.isImperial
          ? weather.temperature.value.toFahrenheit()
          : weather.temperature.value;
      final windSpeed =
          units.isImperial ? weather.windSpeed.toMph() : weather.windSpeed;
      final visibility =
          units.isImperial ? weather.visibility.toMph() : weather.visibility;
      final feelsLike = units.isImperial
          ? weather.feelsLike.toFahrenheit()
          : weather.feelsLike;

      emit(
        state.copyWith(
          status: WeatherStatus.success,
          units: units,
          weather: weather.copyWith(
            temperature: Temperature(value: temperatureValue),
            windSpeed: windSpeed,
            latitude: latitude,
            longitude: longitude,
            visibility: visibility,
            feelsLike: feelsLike,
            humidity: weather.humidity,
            windDirection: weather.windDirection,
            condition: weather.condition,
          ),
          hourly: weatherHourly.copyWith(
            temperature: temperatureHourly,
            isDay: weatherHourly.isDay,
            time: weatherHourly.time,
            condition: weatherHourly.condition,
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

      final windSpeed = units.isMetric
          ? weather.windSpeed.toKmph()
          : weather.windSpeed.toMph();

      final visibility = units.isMetric
          ? weather.visibility.toKmph()
          : weather.visibility.toMph();

      final feelsLike = units.isMetric
          ? weather.feelsLike.toCelsius()
          : weather.feelsLike.toFahrenheit();
      emit(
        state.copyWith(
          units: units,
          weather: weather.copyWith(
            temperature: Temperature(value: temperatureValue),
            windSpeed: windSpeed,
            visibility: visibility,
            feelsLike: feelsLike,
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
