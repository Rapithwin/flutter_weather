import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_meteo_api/open_meteo_api.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  late http.Client httpClient;
  late OpenMeteoApiClient apiClient;

  group("OpenMeteoApiClient", () {
    // Runs before any test runs.
    setUpAll(() {
      // registerFallbackValue(FakeUri()) ensures that if
      // a mock method is called with an argument of type Uri,
      // but no valid instance is available, a FakeUri() instance
      // will be used instead.
      registerFallbackValue(FakeUri());
    });

    // Runs before each individual test.
    setUp(() {
      httpClient = MockHttpClient();
      apiClient = OpenMeteoApiClient(httpClient: httpClient);
    });
    group("constructor", () {
      test("Does not require an httpClient", () {
        expect(OpenMeteoApiClient(), isNotNull);
      });
    });
    group("locationSearch", () {
      final query = "mock-query";
      test("makes correct http request", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn("{}");
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.locationSearch(query);
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              "geocoding-api.open-meteo.com",
              "/v1/search",
              {"name": query, "count": "15"},
            ),
          ),
        ).called(1);
      });

      test("throws LocationRequestFailure on non-200 response", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.locationSearch(query),
          throwsA(isA<LocationRequestFailure>()),
        );
      });

      test("throws LocationNotFoundFailure on error response", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn("{}");
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.locationSearch(query),
          throwsA(isA<LocationNotFoundFailure>()),
        );
      });

      test("throws LocationNotFoundFailure on empty response", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"results": []}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.locationSearch(query),
          throwsA(isA<LocationNotFoundFailure>()),
        );
      });

      test("returns location on valid response", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
  "results": [
    {
      "id": 4887398,
      "name": "Chicago",
      "latitude": 41.85003,
      "longitude": -87.65005,
      "country": "United States"
    }
  ]
}''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.locationSearch(query);
        expect(
          actual,
          isA<List<Location>>()
              .having((l) => l[0].id, "id", 4887398)
              .having((l) => l[0].name, "name", "Chicago")
              .having((l) => l[0].latitude, "latitude", 41.85003)
              .having((l) => l[0].longitude, "longitude", -87.65005)
              .having((l) => l[0].country, "country", "United States"),
        );
      });
    });

    group("getWeather", () {
      const latitude = 41.85003;
      const longitude = -87.6500;
      test("makes correct http request", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn("{}");
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await apiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          );
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https(
              "api.open-meteo.com",
              "/v1/forecast",
              {
                "latitude": "$latitude",
                "longitude": "$longitude",
                "current":
                    "temperature,windspeed,is_day,weathercode,wind_direction_10m,apparent_temperature,relative_humidity_2m,visibility",
              },
            ),
          ),
        ).called(1);
      });
      test("throws WeatherRequestFailure on non-200 response", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
          throwsA(isA<WeatherRequestFailure>()),
        );
      });
      test("throws WeatherNotFoundFailure on error response", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn("{}");
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
          throwsA(isA<WeatherNotFoundFailure>()),
        );
      });
      test("throws WeatherNotFoundFailure on empty response", () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{"results": []}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        await expectLater(
          apiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          ),
          throwsA(isA<WeatherNotFoundFailure>()),
        );
      });
      test('returns weather on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
"latitude": 43,
"longitude": -87.875,
"generationtime_ms": 0.2510547637939453,
"utc_offset_seconds": 0,
"timezone": "GMT",
"timezone_abbreviation": "GMT",
"elevation": 189,
"current": {
    "time": "2025-03-26T15:00",
    "interval": 900,
    "temperature": 15.3,
    "windspeed": 4.5,
    "winddirection": 196,
    "is_day": 0,
    "weathercode": 63,
    "wind_direction_10m": 196,
    "apparent_temperature": 12.9,
    "relative_humidity_2m": 89,
    "visibility": 13000.00
}
}
        ''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.getWeather(
          latitude: latitude,
          longitude: longitude,
        );
        expect(
          actual,
          isA<WeatherCurrent>()
              .having((w) => w.temperature, "temperature", 15.3)
              .having((w) => w.weatherCode, "weatherCode", 63)
              .having((w) => w.isDay, "isDay", 0)
              .having((w) => w.windSpeed, "windSpeed", 4.5)
              .having((w) => w.feelsLike, "apparent temperature", 12.9)
              .having((w) => w.humidity, "relative humidity", 89)
              .having((w) => w.windDirection, "wind direction", 196)
              .having((w) => w.visibility, "visibility", 13000),
        );
      });
    });
  });
}
