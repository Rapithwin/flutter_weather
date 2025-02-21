import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

/// This screen will display after the user has selected a city
/// and we have recieved the data.
class WeatherPopulated extends StatelessWidget {
  const WeatherPopulated({
    super.key,
    required this.weather,
    required this.units,
    required this.onRefresh,
  });

  final Weather weather;
  final TemperatureUnits units;
  final AsyncValueGetter<void> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        _WeatherBackground(),
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.condition});

  final WeatherCondition condition;

  static const _iconSize = 75.0;

  @override
  Widget build(BuildContext context) {
    return Text(
      condition.toEmoji,
      style: const TextStyle(
        fontSize: _iconSize,
      ),
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(context) {
    final color = Theme.of(context).colorScheme.primaryContainer;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.brighten(),
              color.brighten(33),
              color.brighten(50),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.25, 0.75, 0.90, 1.0],
          ),
        ),
      ),
    );
  }
}

extension on WeatherCondition {
  /// This method added to [WeatherCondition] allows you to
  /// show an emoji for each weather condition.
  String get toEmoji {
    switch (this) {
      case WeatherCondition.clear:
        return '☀️';
      case WeatherCondition.rainy:
        return '🌧️';
      case WeatherCondition.cloudy:
        return '☁️';
      case WeatherCondition.snowy:
        return '🌨️';
      case WeatherCondition.unknown:
        return '❓';
    }
  }
}

extension on Color {
  /// This method added to [Color] allows you to increase the
  /// brightness of a color by a given percentage.
  Color brighten([int percent = 10]) {
    assert(
      1 <= percent && percent <= 100,
      "percentage must be between 1 and 100",
    );
    final p = percent / 100;
    final alpha = a.round();
    final red = r.round();
    final green = g.round();
    final blue = b.round();
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}

extension on Weather {
  /// This method added to [Weather] allows you to
  /// format the temperature.
  String formattedTemperature(TemperatureUnits units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isCelsius ? 'C' : 'F'}''';
  }
}
