// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

import '../../helpers/hydrated_bloc.dart';

const weatherLocation = "london";
const weatherCondition = weather_repository.WeatherCondition.rainy;
const weatherTemperature = 9.8;

class MockWeatherRepository extends Mock
    implements weather_repository.WeatherRepository {}

class MockWeather extends Mock implements weather_repository.Weather {}

void main() {
  initHydratedStorage();

  group("weatherCubit", () {
    late weather_repository.Weather weather;
    late weather_repository.WeatherRepository weatherRepository;
    late WeatherCubit weatherCubit;

    setUp(() async {
      weather = MockWeather();
      weatherRepository = MockWeatherRepository();
      weatherCubit = WeatherCubit(weatherRepository);
      when(() => weather.condition).thenReturn(weatherCondition);
      when(() => weather.location).thenReturn(weatherLocation);
      when(() => weather.temperature).thenReturn(weatherTemperature);
      when(
        () => weatherRepository.getWeather(any()),
      ).thenAnswer((_) async => weather);
    });

    test("Initial state is correct", () {
      final weatherCubit = WeatherCubit(weatherRepository);
      expect(weatherCubit.state, WeatherState());
    });

    group("toJson/fromJson", () {
      test("works properly", () {
        final weatherCubit = WeatherCubit(weatherRepository);
        expect(
            weatherCubit.fromJson(
              weatherCubit.toJson(weatherCubit.state),
            ),
            weatherCubit.state);
      });
    });
  });
}
