import 'package:bloc_weather/settings/settings.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

/// This screen will display after the user has selected a city
/// and we have recieved the data.
class WeatherPopulated extends StatefulWidget {
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
  State<WeatherPopulated> createState() => _WeatherPopulatedState();
}

class _WeatherPopulatedState extends State<WeatherPopulated> {
  @override
  void initState() {
    widget.onRefresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    double top = 0.0;
    double paddingTop = MediaQuery.paddingOf(context).top;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: theme.colorScheme.primary,
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
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
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      // top == paddingTop + kToolbarHeight is telling me when app bar
                      // is collapsed so I can show different sizes based on it.
                      title: top == paddingTop + kToolbarHeight
                          ? Container(
                              width: size.width / 1.5,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: paddingTop),
                              child: Text(
                                widget.weather.location,
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.08,
                                ),
                                maxLines: 1,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                widget.weather.location,
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.08,
                                ),
                                maxLines: 2,
                              ),
                            ),
                      centerTitle: true,
                      background: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 100),
                              _WeatherIcon(
                                condition: widget.weather.condition,
                                isDay: widget.weather.isDay,
                              ),
                              SizedBox(
                                height: size.height / 30,
                              ),
                              Text(
                                widget.weather
                                    .formattedTemperature(widget.units),
                                style: theme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '''Last Updated at ${TimeOfDay.fromDateTime(widget.weather.lastUpdated).format(context)}''',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  children: [
                    GridContainer(
                      theme: theme,
                      title: "Wind speed",
                      value: widget.weather.formattedSpeed(widget.units),
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Feels like",
                      value: widget.weather.formattedFeelsLike(widget.units),
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Humidity",
                      value: "${widget.weather.humidity}%",
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Visibility",
                      value: widget.weather.formattedVisibility(widget.units),
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
          children: [
            Text(
              title ?? "",
              style: theme.textTheme.titleMedium,
            ),
            Flexible(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  value ?? "",
                  style: theme.textTheme.displayMedium,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
    return Icon(
      IconData(
        condition.toEmoji(isDay),
        fontFamily: "CustomIcons",
      ),
      size: _iconSize,
      color: Theme.of(context).colorScheme.onPrimary,
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
  toEmoji(bool isDay) {
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
