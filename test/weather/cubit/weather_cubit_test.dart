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
const isDay = true;
const windSpeed = 4.5;
const latitude = 41.85003;
const longitude = -87.65005;

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
      when(() => weather.isDay).thenReturn(isDay);
      when(() => weather.windSpeed).thenReturn(windSpeed);
      when(
        () => weatherRepository.getWeather(any(), any(), any()),
      ).thenAnswer((_) async => weather);
    });

    test("Initial state is correct", () {
      weatherCubit = WeatherCubit(weatherRepository);
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
    group("fetchWeather", () {
      blocTest<WeatherCubit, WeatherState>(
        "emits nothing on null input",
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(null, null, null),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        "emits nothing when city is empty",
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather("", latitude, longitude),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'calls getWeather with correct city.',
        build: () => weatherCubit,
        act: (cubit) =>
            cubit.fetchWeather(weatherLocation, latitude, longitude),
        verify: (_) {
          verify(
            () => weatherRepository.getWeather(
                weatherLocation, latitude, longitude),
          ).called(1);
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, failure] when getWeather throws.',
        setUp: () {
          when(() => weatherRepository.getWeather(any(), any(), any()))
              .thenThrow(
            Exception("oops"),
          );
        },
        build: () => weatherCubit,
        act: (cubit) =>
            cubit.fetchWeather(weatherLocation, latitude, longitude),
        expect: () => <WeatherState>[
          WeatherState(status: WeatherStatus.loading),
          WeatherState(status: WeatherStatus.failure),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, success] when getWeather returns (metric).',
        build: () => weatherCubit,
        act: (cubit) =>
            cubit.fetchWeather(weatherLocation, latitude, longitude),
        expect: () => <dynamic>[
          WeatherState(status: WeatherStatus.loading),
          isA<WeatherState>()
              .having(
                (w) => w.status,
                "status",
                WeatherStatus.success,
              )
              .having(
                (w) => w.weather,
                "weather",
                isA<Weather>()
                    .having((w) => w.lastUpdated, "lastUpdated", isNotNull)
                    .having((w) => w.condition, "condition", weatherCondition)
                    .having(
                      (w) => w.temperature,
                      "temperature (metric)",
                      Temperature(value: weatherTemperature),
                    )
                    .having((w) => w.location, "location", weatherLocation)
                    .having((w) => w.isDay, "isDay", isDay)
                    .having(
                        (w) => w.windSpeed, "windSpeed (metric)", windSpeed),
              )
        ],
      );
      blocTest(
        "emits [loading, success] when getWeather returns (imperial)",
        build: () => weatherCubit,
        // seed is used to set an initial state for the bloc
        // before act. In this case we're changing the temperature in the
        // initial state from metric to imperial for the test.
        seed: () => WeatherState(
          units: Units.imperial,
        ),
        act: (cubit) =>
            cubit.fetchWeather(weatherLocation, latitude, longitude),
        expect: () => <dynamic>[
          WeatherState(
            status: WeatherStatus.loading,
            units: Units.imperial,
          ),
          isA<WeatherState>()
              .having(
                (w) => w.status,
                "status",
                WeatherStatus.success,
              )
              .having(
                (w) => w.weather,
                "weather",
                isA<Weather>()
                    .having((w) => w.lastUpdated, "lastUpdated", isNotNull)
                    .having((w) => w.condition, "condition", weatherCondition)
                    .having(
                      (w) => w.temperature,
                      "temperature (imperial)",
                      Temperature(value: weatherTemperature.toFahrenheit()),
                    )
                    .having((w) => w.location, "location", weatherLocation)
                    .having((w) => w.isDay, "isDay", isDay)
                    .having((w) => w.windSpeed, "windSpeed (imperial)",
                        windSpeed.toMph()),
              )
        ],
      );
    });
    group(
      "refreshWeather",
      () {
        blocTest<WeatherCubit, WeatherState>(
          'emits nothing when status is not success.',
          build: () => weatherCubit,
          act: (cubit) => cubit.refreshWeather(),
          expect: () => const <WeatherState>[],
          verify: (_) {
            verifyNever(
                () => weatherRepository.getWeather(any(), any(), any()));
          },
        );

        blocTest<WeatherCubit, WeatherState>(
          'emits nothing when location is null.',
          build: () => weatherCubit,
          seed: () => WeatherState(status: WeatherStatus.success),
          act: (cubit) => cubit.refreshWeather(),
          expect: () => const <WeatherState>[],
          verify: (_) {
            verifyNever(
                () => weatherRepository.getWeather(any(), any(), any()));
          },
        );

        blocTest<WeatherCubit, WeatherState>(
          'invokes getWeather with correct location',
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            weather: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
              isDay: isDay,
              windSpeed: windSpeed,
              latitude: latitude,
              longitude: longitude,
            ),
          ),
          act: (cubit) => cubit.refreshWeather(),
          verify: (_) {
            verify(() => weatherRepository.getWeather(
                weatherLocation, latitude, longitude)).called(1);
          },
        );

        blocTest(
          "emits nothing when exception is thrown",
          setUp: () {
            when(() => weatherRepository.getWeather(any(), any(), any()))
                .thenThrow(Exception("oops"));
          },
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            weather: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
              isDay: isDay,
              windSpeed: windSpeed,
              latitude: latitude,
              longitude: longitude,
            ),
          ),
          act: (cubit) => cubit.refreshWeather(),
          expect: () => <WeatherState>[],
        );
        blocTest<WeatherCubit, WeatherState>(
          'emits updated weather (metric)',
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            weather: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
              isDay: isDay,
              windSpeed: windSpeed,
              latitude: latitude,
              longitude: longitude,
            ),
          ),
          act: (cubit) => cubit.refreshWeather(),
          expect: () => <Matcher>[
            isA<WeatherState>()
                .having((w) => w.status, "status", WeatherStatus.success)
                .having(
                  (w) => w.weather,
                  "weather",
                  isA<Weather>()
                      .having((w) => w.condition, "condition", weatherCondition)
                      .having((w) => w.lastUpdated, "lastUpdated", isNotNull)
                      .having((w) => w.location, "location", weatherLocation)
                      .having(
                        (w) => w.temperature,
                        "temperature (metric)",
                        Temperature(
                          value: weatherTemperature,
                        ),
                      )
                      .having((w) => w.isDay, "isDay", isDay)
                      .having(
                          (w) => w.windSpeed, "windSpeed (metric)", windSpeed),
                )
          ],
        );

        blocTest<WeatherCubit, WeatherState>(
          'emits updated weather (imperial)',
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            units: Units.imperial,
            weather: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
              isDay: isDay,
              windSpeed: windSpeed,
              latitude: latitude,
              longitude: longitude,
            ),
          ),
          act: (cubit) => cubit.refreshWeather(),
          expect: () => <Matcher>[
            isA<WeatherState>()
                .having((w) => w.status, "status", WeatherStatus.success)
                .having(
                  (w) => w.weather,
                  "weather",
                  isA<Weather>()
                      .having((w) => w.condition, "condition", weatherCondition)
                      .having((w) => w.lastUpdated, "lastUpdated", isNotNull)
                      .having((w) => w.location, "location", weatherLocation)
                      .having(
                        (w) => w.temperature,
                        "temperature (imperial)",
                        Temperature(
                          value: weatherTemperature.toFahrenheit(),
                        ),
                      )
                      .having((w) => w.isDay, "isDay", isDay)
                      .having((w) => w.windSpeed, "windSpeed (imperial)",
                          windSpeed.toMph()),
                )
          ],
        );
      },
    );

    group("toggleUnits", () {
      blocTest<WeatherCubit, WeatherState>(
        'emits updated units when status is not success',
        build: () => weatherCubit,
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          WeatherState(units: Units.imperial),
        ],
      );
      blocTest<WeatherCubit, WeatherState>(
        'emits updated units and temperature'
        'when status is success (metric)',
        build: () => weatherCubit,
        seed: () => WeatherState(
          status: WeatherStatus.success,
          units: Units.imperial,
          weather: Weather(
            condition: weatherCondition,
            lastUpdated: DateTime(2020),
            location: weatherLocation,
            temperature: Temperature(
              value: weatherTemperature,
            ),
            isDay: isDay,
            windSpeed: windSpeed,
          ),
        ),
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          WeatherState(
            status: WeatherStatus.success,
            units: Units.metric,
            weather: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature.toCelsius(),
              ),
              isDay: isDay,
              windSpeed: windSpeed.toKmph(),
            ),
          ),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits updated units and temperature'
        'when status is success (imperial)',
        build: () => weatherCubit,
        seed: () => WeatherState(
          status: WeatherStatus.success,
          units: Units.metric,
          weather: Weather(
            condition: weatherCondition,
            lastUpdated: DateTime(2020),
            location: weatherLocation,
            temperature: Temperature(
              value: weatherTemperature,
            ),
            isDay: isDay,
            windSpeed: windSpeed,
          ),
        ),
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          WeatherState(
            status: WeatherStatus.success,
            units: Units.imperial,
            weather: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature.toFahrenheit(),
              ),
              isDay: isDay,
              windSpeed: windSpeed.toMph(),
            ),
          ),
        ],
      );
    });
  });
}
