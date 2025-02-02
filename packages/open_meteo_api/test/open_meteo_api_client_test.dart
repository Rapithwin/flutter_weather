import 'dart:io';

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
  });
  group("constructor", () {});
  group("locationSearch", () {});
  group("getWeather", () {});
}
