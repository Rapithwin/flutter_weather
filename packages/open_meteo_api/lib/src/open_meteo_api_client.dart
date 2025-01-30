import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:open_meteo_api/open_meteo_api.dart';

/// Exception thrown when location request fails.
class LocationRequestFailure implements Exception {}

/// Exception thrown when location is not found.
class LocationNotFoundFailure implements Exception {}

class WeatherFoundFailure implements Exception {}

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
      {"name": query, "count": 1},
    );

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) throw LocationRequestFailure();

    final locationJson = jsonDecode(locationResponse.body) as Map;

    if (!locationJson.containsKey("result")) throw LocationNotFoundFailure();

    final result = locationJson["result"] as List;

    return Location.fromJson(result.first as Map<String, dynamic>);
  }

  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) {}
}
