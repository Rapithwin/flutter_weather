import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:bloc_weather/weather/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:bloc_weather/weather/weather.dart';

import '../../helpers/hydrated_bloc.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeatherCubit extends MockCubit<WeatherState>
    implements WeatherCubit {}

void main() {
  initHydratedStorage();

  group("weatherPage", () {
    final weather = Weather(
      location: "London",
      temperature: Temperature(value: 4.2),
      condition: WeatherCondition.cloudy,
      isDay: true,
      windSpeed: 12.2,
      lastUpdated: DateTime(2020),
    );

    late WeatherCubit weatherCubit;

    setUp(() {
      weatherCubit = MockWeatherCubit();
    });
  });
}
