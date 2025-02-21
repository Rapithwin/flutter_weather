import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
