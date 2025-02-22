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
  final Units units;
  final AsyncValueGetter<void> onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        _WeatherBackground(),
        RefreshIndicator(
          onRefresh: onRefresh,
          child: Align(
            alignment: const Alignment(0, -1 / 3),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 48),
                  _WeatherIcon(
                    condition: weather.condition,
                    isDay: weather.isDay,
                  ),
                  Text(
                    weather.location,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weather.formattedTemperature(units),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Wind Speed: ${weather.formattedSpeed(units)}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '''Last Updated at ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.condition, required this.isDay});

  final WeatherCondition condition;
  final bool isDay;

  static const _iconSize = 75.0;

  @override
  Widget build(BuildContext context) {
    return Text(
      condition.toEmoji(isDay),
      style: const TextStyle(
        fontSize: _iconSize,
      ),
    );
  }
}

class _WeatherBackground extends StatelessWidget {
  @override
  Widget build(context) {
    final color = Theme.of(context).colorScheme.primary;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 60),
              color.withValues(alpha: 90),
              color.withValues(alpha: 120),
              color.withValues(alpha: 150),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.21, 0.40, 0.65, 1],
          ),
        ),
      ),
    );
  }
}

extension on WeatherCondition {
  /// This method added to [WeatherCondition] allows you to
  /// show an emoji for each weather condition.
  String toEmoji(bool isDay) {
    switch (this) {
      case WeatherCondition.clear:
        return isDay ? '☀️' : '🌙';
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

extension on Weather {
  /// This method added to [Weather] allows you to
  /// format the temperature.
  String formattedTemperature(Units units) {
    return '''${temperature.value.toStringAsPrecision(2)}°${units.isMetric ? 'C' : 'F'}''';
  }

  String formattedSpeed(Units units) {
    return '''$windSpeed${units.isMetric ? 'km/h' : 'm/h'}''';
  }
}
