import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception thrown when location request fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when when weather for provided location is not found.
class WeatherFoundFailure implements Exception {}

/// Exception thrown when `getWeather()` fails.
class WeatherRequestFailure implements Exception {}

/// {@template opoen_meteo_api}
///  Dart API Client which wraps the [Open Meteo API](https://open-meteo.com).
/// {@endtemplate}
class OpenMeteoApiClient {
  /// {@macro open_meteo_api}
  OpenMeteoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();
  final http.Client _httpClient;

  static const _baseUrlWeather = 'api.open-meteo.com';
  static const _baseUrlGeocoding = 'geocoding-api.open-meteo.com';

  /// Finds a [Location] `/v1/search/?name=(query)`.
  Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      "/v1/search",
      {"name": query, "count": "1"},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) throw LocationRequestFailure();

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey("result")) throw LocationNotFoundFailure();

    final result = locationJson["result"] as List;

    return Location.fromJson(result.first as Map<String, dynamic>);
  }

  /// Fetches [Weather] for a given [Latitude] and  [Longitude].
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final weatherRequest = Uri.https(
      _baseUrlWeather,
      "/v1/forecast",
      {
        "latitude": latitude,
        "longitude": longitude,
      },
    );

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) throw WeatherRequestFailure();

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey("current_weather")) throw WeatherFoundFailure();

    final weatherJson = bodyJson["current_weather"] as Map<String, dynamic>;

    return Weather.fromJson(weatherJson);
  }
}
