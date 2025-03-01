import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart' as open_meteo_api;

import 'package:weather_repository/weather_repository.dart';

class MockOpenMeteoApiClient extends Mock
    implements open_meteo_api.OpenMeteoApiClient {}

class MockLocation extends Mock implements open_meteo_api.Location {}

class MockWeather extends Mock implements open_meteo_api.Weather {}

void main() {
  group("WeatherRepository", () {
    late open_meteo_api.OpenMeteoApiClient weatherApiClient;
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherApiClient = MockOpenMeteoApiClient();
      weatherRepository = WeatherRepository(
        weatherApiClient: weatherApiClient,
      );
    });
    group('constructor', () {
      test('instantiates internal weather api client when not injected', () {
        expect(WeatherRepository(), isNotNull);
      });
    });

    group("getLocation", () {
      const city = 'chicago';
      const country = "United States";

      test("calls locatoinSearch with correct city", () async {
        try {
          await weatherRepository.getLocation(city);
        } catch (_) {}
        verify(
          () => weatherApiClient.locationSearch(city),
        ).called(1);
      });

      test("throws when locationSerach fails", () {
        final exception = Exception("oops");
        when(() => weatherApiClient.locationSearch(any())).thenThrow(exception);
        expectLater(
          () => weatherRepository.getLocation(city),
          throwsA(exception),
        );
      });

      test("returns correct response on success", () async {
        final location = MockLocation();

        when(() => location.name).thenReturn(city);
        when(() => location.country).thenReturn(country);
        when(() => weatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => [location]);

        final actual = await weatherRepository.getLocation(city);
        expect(actual, [
          Location(
            city: city,
            country: country,
          )
        ]);
      });
    });
    group("getWeather", () {
      const city = 'chicago';
      const latitude = 41.85003;
      const longitude = -87.65005;

      test("calls getWeather with correct latitude/longitude", () async {
        final location = MockLocation();
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => [location]);

        try {
          await weatherRepository.getWeather(city, 0);
        } catch (_) {}
        verify(() => weatherApiClient.getWeather(
              latitude: latitude,
              longitude: longitude,
            )).called(1);
      });

      test("throws when getWeather fails", () async {
        final location = MockLocation();
        final exception = Exception("oops");
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(
          () => weatherApiClient.locationSearch(any()),
        ).thenAnswer((_) async => [location]);
        when(() => weatherApiClient.getWeather(
              latitude: any(named: "latitude"),
              longitude: any(named: "longitude"),
            )).thenThrow(exception);
        expect(
          weatherRepository.getWeather(city, 0),
          throwsA(exception),
        );
      });
      test("returns correct response on success (clear)", () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(0);
        when(() => weather.isDay).thenReturn(0);
        when(() => weather.windSpeed).thenReturn(4.5);
        when(() => weatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => [location]);
        when(() => weatherApiClient.getWeather(
              latitude: any(named: "latitude"),
              longitude: any(named: "longitude"),
            )).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city, 0);
        expect(
            actual,
            Weather(
              location: city,
              temperature: 42.42,
              condition: WeatherCondition.clear,
              isDay: false,
              windSpeed: 4.5,
            ));
      });
      test("returns correct response on success (cloudy)", () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(48);
        when(() => weather.isDay).thenReturn(1);
        when(() => weather.windSpeed).thenReturn(4.5);
        when(() => weatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => [location]);
        when(() => weatherApiClient.getWeather(
              latitude: any(named: "latitude"),
              longitude: any(named: "longitude"),
            )).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city, 0);
        expect(
            actual,
            Weather(
                location: city,
                temperature: 42.42,
                condition: WeatherCondition.cloudy,
                isDay: true,
                windSpeed: 4.5));
      });
      test("returns correct response on success rainy)", () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(99);
        when(() => weather.isDay).thenReturn(1);
        when(() => weather.windSpeed).thenReturn(4.5);
        when(() => weatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => [location]);
        when(() => weatherApiClient.getWeather(
              latitude: any(named: "latitude"),
              longitude: any(named: "longitude"),
            )).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city, 0);
        expect(
            actual,
            Weather(
              location: city,
              temperature: 42.42,
              condition: WeatherCondition.rainy,
              isDay: true,
              windSpeed: 4.5,
            ));
      });
      test("returns correct response on success (snowy)", () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(86);
        when(() => weather.isDay).thenReturn(1);
        when(() => weather.windSpeed).thenReturn(4.5);
        when(() => weatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => [location]);
        when(() => weatherApiClient.getWeather(
              latitude: any(named: "latitude"),
              longitude: any(named: "longitude"),
            )).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city, 0);
        expect(
            actual,
            Weather(
              location: city,
              temperature: 42.42,
              condition: WeatherCondition.snowy,
              isDay: true,
              windSpeed: 4.5,
            ));
      });
      test("returns correct response on success (unknown)", () async {
        final location = MockLocation();
        final weather = MockWeather();
        when(() => location.name).thenReturn(city);
        when(() => location.latitude).thenReturn(latitude);
        when(() => location.longitude).thenReturn(longitude);
        when(() => weather.temperature).thenReturn(42.42);
        when(() => weather.weatherCode).thenReturn(-1);
        when(() => weather.isDay).thenReturn(1);
        when(() => weather.windSpeed).thenReturn(4.5);
        when(() => weatherApiClient.locationSearch(any()))
            .thenAnswer((_) async => [location]);
        when(() => weatherApiClient.getWeather(
              latitude: any(named: "latitude"),
              longitude: any(named: "longitude"),
            )).thenAnswer((_) async => weather);
        final actual = await weatherRepository.getWeather(city, 0);
        expect(
            actual,
            Weather(
              location: city,
              temperature: 42.42,
              condition: WeatherCondition.unknown,
              isDay: true,
              windSpeed: 4.5,
            ));
      });
    });
  });
}
