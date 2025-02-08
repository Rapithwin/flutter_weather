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
              {"name": query, "count": "1"},
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
      "longitude": -87.65005
    }
  ]
}''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await apiClient.locationSearch(query);
        expect(
          actual,
          isA<Location>()
              .having((l) => l.id, "id", 4887398)
              .having((l) => l.name, "name", "Chicago")
              .having((l) => l.latitude, "latitude", 41.85003)
              .having((l) => l.longitude, "longitude", -87.65005),
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
                "current_weather": "true",
              },
            ),
          ),
        ).called(1);
      });
    });
  });
}
