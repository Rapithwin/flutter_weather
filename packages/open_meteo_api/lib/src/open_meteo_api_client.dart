import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception thrown when location request fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when location is not found.
class LocationNotFoundFailure implements Exception {}

/// Exception thrown when when weather for provided location is not found.
class WeatherNotFoundFailure implements Exception {}

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
  Future<List<Location>> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrlGeocoding,
      "/v1/search",
      {"name": query, "count": "15"},
    );

    final locationResponse = await _httpClient
        .get(
      locationRequest,
    )
        .timeout(
      Duration(seconds: 7),
      onTimeout: () {
        throw Exception("Request timed out");
      },
    );

    if (locationResponse.statusCode != 200) throw LocationRequestFailure();

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey("results")) throw LocationNotFoundFailure();

    final result = (locationJson["results"] as List)
        .map((e) => Location.fromJson(e))
        .toList();

    if (result.isEmpty) throw LocationNotFoundFailure();

    return result;
  }

  /// Fetches [WeatherCurrent] for a given [Latitude] and  [Longitude].
  Future<WeatherCurrent> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final String currentQuery =
        "temperature,windspeed,is_day,weathercode,wind_direction_10m,apparent_temperature,relative_humidity_2m";
    final weatherRequest = Uri.https(
      _baseUrlWeather,
      "/v1/forecast",
      {
        "latitude": "$latitude",
        "longitude": "$longitude",
        "current": currentQuery,
      },
    );

    final weatherResponse = await _httpClient
        .get(
      weatherRequest,
    )
        .timeout(
      Duration(seconds: 7),
      onTimeout: () {
        throw Exception("Request timed out");
      },
    );

    if (weatherResponse.statusCode != 200) throw WeatherRequestFailure();

    final bodyJson = jsonDecode(weatherResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey("current")) {
      throw WeatherNotFoundFailure();
    }

    final weatherJson = bodyJson["current"] as Map<String, dynamic>;

    return WeatherCurrent.fromJson(weatherJson);
  }
}
