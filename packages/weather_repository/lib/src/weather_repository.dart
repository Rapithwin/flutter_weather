import 'dart:async';

import 'package:intl/intl.dart' show DateFormat;
import 'package:open_meteo_api/open_meteo_api.dart' show OpenMeteoApiClient;
import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {
  final OpenMeteoApiClient _weatherApiClient;

  WeatherRepository({OpenMeteoApiClient? weatherApiClient})
      : _weatherApiClient = weatherApiClient ?? OpenMeteoApiClient();

  Future<List<Location>> getLocation(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    return location
        .map((e) => Location(
              city: e.name,
              country: e.country,
              latitude: e.latitude,
              longitude: e.longitude,
            ))
        .toList();
  }

  Future<Weather> getWeather(
    String city,
    double latitude,
    double longitude,
  ) async {
    final weather = await _weatherApiClient.getWeather(
      latitude: latitude,
      longitude: longitude,
    );
    return Weather(
      location: city,
      temperature: weather.temperature,
      condition: weather.weatherCode.toInt().toCondition,
      isDay: weather.isDay.toBool,
      windSpeed: weather.windSpeed,
      feelsLike: weather.feelsLike,
      humidity: weather.humidity,
      windDirection: weather.windDirection.toDirectionStr,
      visibility: weather.visibility,
    );
  }

  Future<WeatherHourly> getForecastHourly(
    double latitude,
    double longitude,
  ) async {
    final hourly = await _weatherApiClient.getForecastHourly(
      latitude: latitude,
      longitude: longitude,
    );
    final List<String> timeSplit =
        hourly.time.map((element) => element.split("T")[1]).toList();
    final List<bool> dayBool =
        hourly.isDay.map((element) => element.toBool).toList();
    final List<WeatherCondition> weatherCondition =
        hourly.weatherCode.map((element) => element.toCondition).toList();

    return WeatherHourly(
      time: timeSplit,
      temperature: hourly.temperature,
      isDay: dayBool,
      condition: weatherCondition,
    );
  }

  Future<WeatherDaily> getForecastDaily(
    double latitude,
    double longitude,
  ) async {
    final daily = await _weatherApiClient.getForecastDaily(
      latitude: latitude,
      longitude: longitude,
    );

    final formattedWeekday = daily.time.map((element) {
      final DateTime toDateTime = DateTime.parse(element);
      return DateFormat("E").format(toDateTime);
    }).toList();

    final List<String> windDirectionStr =
        daily.windDirection.map((element) => element.toDirectionStr).toList();

    final List<WeatherCondition> weatherCondition =
        daily.weatherCode.map((element) => element.toCondition).toList();

    return WeatherDaily(
      time: formattedWeekday,
      temperatureMin: daily.minTemperature,
      temperatureMax: daily.maxTemperature,
      windSpeed: daily.windSpeed,
      windDirection: windDirectionStr,
      condition: weatherCondition,
    );
  }
}

extension on int {
  /// Converts the weather code into a weather condition.
  WeatherCondition get toCondition {
    switch (this) {
      case 0:
        return WeatherCondition.clear;
      case 1:
        return WeatherCondition.mainlyClear;
      case 2:
        return WeatherCondition.partlyCloudy;
      case 3:
        return WeatherCondition.cloudy;
      case 45:
        return WeatherCondition.foggy;
      case 48:
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
        return WeatherCondition.rainy;
      case 63:
        return WeatherCondition.rainy;
      case 65:
        return WeatherCondition.rainy;
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
        return WeatherCondition.thunderstorm;
      case 96:
      case 99:
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
        return WeatherCondition.snowy;
      case 86:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }

  bool get toBool {
    return this == 1;
  }
}

extension on double {
  String get toDirectionStr {
    if (this >= -22.5 && this < 22.5) return "N";
    if (this >= 22.5 && this < 67.5) return "NE";
    if (this >= 67.5 && this < 112.5) return "E";
    if (this >= 112.5 && this < 157.5) return "SE";
    if (this >= 157.5 && this < 202.5) return "S";
    if (this >= 202.5 && this < 247.5) return "SW";
    if (this >= 247.5 && this < 292.5) return "W";
    if (this >= 292.5 && this < 337.5) return "NW";
    throw Exception("Invalid Direction");
  }
}
