import 'package:weather_repository/weather_repository.dart'
    hide Weather, WeatherHourly;
import 'package:bloc_weather/weather/weather.dart';

extension WeatherConditionToEmoji on WeatherCondition {
  /// This method added to [WeatherCondition] allows you to
  /// show an emoji for each weather condition.
  int toEmoji(bool isDay) {
    switch (this) {
      case WeatherCondition.clear:
        return isDay ? 0xf00d : 0xf02e;
      case WeatherCondition.mainlyClear:
        return isDay ? 0xf00c : 0xf081;
      case WeatherCondition.partlyCloudy:
        return isDay ? 0xf002 : 0xf086;
      case WeatherCondition.rainy:
        return 0xf019;
      case WeatherCondition.cloudy:
        return 0xf041;
      case WeatherCondition.snowy:
        return 0xf01b;
      case WeatherCondition.foggy:
        return 0xf014;
      case WeatherCondition.thunderstorm:
        return 0xf01e;

      case WeatherCondition.unknown:
        return 0xf07b;
    }
  }
}

extension WindDirectionToIcon on String {
  /// This method added to [String] allows you to
  /// show an icon for each wind direction.
  int windDirectionToIcon() {
    switch (this) {
      case "N":
        return 0xf058;
      case "NE":
        return 0xf057;
      case "E":
        return 0xf04d;
      case "SE":
        return 0xf088;
      case "S":
        return 0xf044;
      case "SW":
        return 0xf043;
      case "W":
        return 0xf048;
      case "NW":
        return 0xf087;
      default:
        return 0xf07b;
    }
  }
}

extension WeatherFormatting on double {
  /// This method added to [double] allows you to
  /// format the temperature.
  String formattedTemperature(Units units) {
    return '''${toStringAsPrecision(2)}°${units.isMetric ? 'C' : 'F'}''';
  }

  String formattedSpeed(Units units) {
    return '''${toStringAsPrecision(3)}
${units.isMetric ? 'kmph' : 'mph'}''';
  }

  String formattedVisibility(Units units) {
    return '''${(this / 1000).toStringAsFixed(1)}
${units.isMetric ? 'km' : 'miles'}''';
  }
}
