import 'package:bloc_weather/settings/settings.dart';
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
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: theme.colorScheme.primary,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Stack(
          children: [
            _WeatherBackground(),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: size.height / 2.2,
                  pinned: true,
                  backgroundColor: theme.colorScheme.primary,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(SettingsPage.route());
                      },
                      icon: Icon(
                        Icons.settings,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    title: Text(
                      weather.location,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    background: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 130),
                            _WeatherIcon(
                              condition: weather.condition,
                              isDay: weather.isDay,
                            ),
                            Text(
                              weather.formattedTemperature(units),
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '''Last Updated at ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}''',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  children: [
                    GridContainer(
                      theme: theme,
                      title: "Wind speed",
                      value: weather.formattedSpeed(units),
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Feels like",
                      value: weather.formattedFeelsLike(units),
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Humidity",
                      value: "${weather.humidity}%",
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Visibility",
                      value: weather.formattedVisibility(units),
                    ),
                  ],
                ),
                SliverList.list(children: [
                  SizedBox(
                    height: 20,
                  ),
                  GridContainer(
                    theme: theme,
                    height: 230,
                  ),
                  SizedBox(
                    height: 130,
                  )
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GridContainer extends StatelessWidget {
  const GridContainer({
    super.key,
    required this.theme,
    this.height,
    this.title,
    this.value,
  });

  final ThemeData theme;
  final double? height;
  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: height ?? 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withAlpha(60),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 30,
          children: [
            Text(
              title ?? "",
              style: theme.textTheme.titleMedium,
            ),
            Text(
              value ?? "",
              style: theme.textTheme.displayMedium,
              maxLines: 2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({required this.condition, required this.isDay});

  final WeatherCondition condition;
  final bool isDay;

  static const _iconSize = 105.0;

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

  String formattedFeelsLike(Units units) {
    return '''${feelsLike.toStringAsPrecision(2)}°${units.isMetric ? 'C' : 'F'}''';
  }

  String formattedSpeed(Units units) {
    return '''${windSpeed.toStringAsPrecision(3)}
${units.isMetric ? 'kmph' : 'mph'}''';
  }

  String formattedVisibility(Units units) {
    return '''${(visibility / 1000).toStringAsFixed(1)}
${units.isMetric ? 'km' : 'miles'}''';
  }
}
