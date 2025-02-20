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
        "emits nothing when city is null",
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(null),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        "emits nothing when city is empty",
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(""),
        expect: () => <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'calls getWeather with correct city.',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(weatherLocation),
        verify: (_) {
          verify(
            () => weatherRepository.getWeather(weatherLocation),
          ).called(1);
        },
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, failure] when getWeather throws.',
        setUp: () {
          when(() => weatherRepository.getWeather(any())).thenThrow(
            Exception("oops"),
          );
        },
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(weatherLocation),
        expect: () => <WeatherState>[
          WeatherState(status: WeatherStatus.loading),
          WeatherState(status: WeatherStatus.failure),
        ],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits [loading, success] when getWeather returns (culsius).',
        build: () => weatherCubit,
        act: (cubit) => cubit.fetchWeather(weatherLocation),
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
                      "temperature (celsius)",
                      Temperature(value: weatherTemperature),
                    )
                    .having((w) => w.location, "location", weatherLocation),
              )
        ],
      );
      blocTest(
        "emits [loading, success] when getWeather returns (fahrenheit)",
        build: () => weatherCubit,
        // seed is used to set an initial state for the bloc
        // before act. In this case we're changing the temperature in the
        // initial state from celsius to fahrenheit for the test.
        seed: () => WeatherState(
          temperatureUnits: TemperatureUnits.fahrenheit,
        ),
        act: (cubit) => cubit.fetchWeather(weatherLocation),
        expect: () => <dynamic>[
          WeatherState(
            status: WeatherStatus.loading,
            temperatureUnits: TemperatureUnits.fahrenheit,
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
                      "temperature (fahrenheit)",
                      Temperature(value: weatherTemperature.toFahrenheit()),
                    )
                    .having((w) => w.location, "location", weatherLocation),
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
            verifyNever(() => weatherRepository.getWeather(any()));
          },
        );

        blocTest<WeatherCubit, WeatherState>(
          'emits nothing when location is null.',
          build: () => weatherCubit,
          seed: () => WeatherState(status: WeatherStatus.success),
          act: (cubit) => cubit.refreshWeather(),
          expect: () => const <WeatherState>[],
          verify: (_) {
            verifyNever(() => weatherRepository.getWeather(any()));
          },
        );

        blocTest<WeatherCubit, WeatherState>(
          'invokes getWeather with correct location',
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            weahter: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
            ),
          ),
          act: (cubit) => cubit.refreshWeather(),
          verify: (_) {
            verify(() => weatherRepository.getWeather(weatherLocation))
                .called(1);
          },
        );

        blocTest(
          "emits nothing when exception is thrown",
          setUp: () {
            when(() => weatherRepository.getWeather(any()))
                .thenThrow(Exception("oops"));
          },
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            weahter: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
            ),
          ),
          act: (cubit) => cubit.refreshWeather(),
          expect: () => <WeatherState>[],
        );
        blocTest<WeatherCubit, WeatherState>(
          'emits updated weather (celsius)',
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            weahter: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
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
                        "temperature (celsius)",
                        Temperature(
                          value: weatherTemperature,
                        ),
                      ),
                )
          ],
        );

        blocTest<WeatherCubit, WeatherState>(
          'emits updated weather (fahrenheit)',
          build: () => weatherCubit,
          seed: () => WeatherState(
            status: WeatherStatus.success,
            temperatureUnits: TemperatureUnits.fahrenheit,
            weahter: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature,
              ),
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
                        "temperature (fahrenheit)",
                        Temperature(
                          value: weatherTemperature.toFahrenheit(),
                        ),
                      ),
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
          WeatherState(temperatureUnits: TemperatureUnits.fahrenheit),
        ],
      );
      blocTest<WeatherCubit, WeatherState>(
        'emits updated units and temperature'
        'when status is success (celsius)',
        build: () => weatherCubit,
        seed: () => WeatherState(
          status: WeatherStatus.success,
          temperatureUnits: TemperatureUnits.fahrenheit,
          weahter: Weather(
            condition: weatherCondition,
            lastUpdated: DateTime(2020),
            location: weatherLocation,
            temperature: Temperature(
              value: weatherTemperature,
            ),
          ),
        ),
        act: (cubit) => cubit.toggleUnits(),
        expect: () => <WeatherState>[
          WeatherState(
            status: WeatherStatus.success,
            weahter: Weather(
              condition: weatherCondition,
              lastUpdated: DateTime(2020),
              location: weatherLocation,
              temperature: Temperature(
                value: weatherTemperature.toCelsius(),
              ),
            ),
          ),
        ],
      );
    });
  });
}
