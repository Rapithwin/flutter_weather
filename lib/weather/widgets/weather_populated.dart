import 'package:bloc_weather/settings/settings.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_repository/weather_repository.dart'
    hide Weather, WeatherHourly;
import 'package:bloc_weather/weather/extensions/extensions.dart';

/// This screen will display after the user has selected a city
/// and we have recieved the data.
class WeatherPopulated extends StatefulWidget {
  const WeatherPopulated({
    super.key,
    required this.weather,
    required this.units,
    required this.onRefresh,
    required this.hourly,
  });

  final Weather weather;
  final WeatherHourly hourly;
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
                              WeatherIcon(
                                condition: widget.weather.condition,
                                isDay: widget.weather.isDay,
                                iconSize: 105.0,
                              ),
                              SizedBox(
                                height: size.height / 30,
                              ),
                              Text(
                                widget.weather.temperature.value
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
                      value: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.weather.windSpeed
                                .formattedSpeed(widget.units),
                            style: theme.textTheme.displayMedium,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            IconData(
                              widget.weather.windDirection
                                  .windDirectionToIcon(),
                              fontFamily: "CustomIcons",
                            ),
                            size: 60,
                            color: theme.colorScheme.onPrimary,
                          )
                        ],
                      ),
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Feels like",
                      value: Text(
                        widget.weather.feelsLike
                            .formattedTemperature(widget.units),
                        style: theme.textTheme.displayMedium,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Humidity",
                      value: Text(
                        "${widget.weather.humidity}%",
                        style: theme.textTheme.displayMedium,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GridContainer(
                      theme: theme,
                      title: "Visibility",
                      value: Text(
                        widget.weather.visibility
                            .formattedVisibility(widget.units),
                        style: theme.textTheme.displayMedium,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SliverList.list(children: [
                  SizedBox(
                    height: 20,
                  ),
                  GridContainer(
                    theme: theme,
                    title: "24-hour forecast",
                    height: size.height / 4.7,
                    value: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.hourly.time.length,
                      itemBuilder: hourlyBuilder,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 9,
                  )
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget? hourlyBuilder(BuildContext context, int index) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: size.width / 7,
      child: Column(
        children: [
          Text(
            widget.hourly.temperature[index].formattedTemperature(widget.units),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: size.height / 15,
          ),
          WeatherIcon(
            condition: widget.hourly.condition[index],
            isDay: widget.hourly.isDay[index],
            iconSize: 30.0,
          ),
          SizedBox(
            height: size.height / 60,
          ),
          Text(widget.hourly.time[index]),
        ],
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
  final Widget? value;

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
                child: value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({
    super.key,
    required this.condition,
    required this.isDay,
    required this.iconSize,
  });

  final WeatherCondition condition;
  final bool isDay;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(
        condition.toEmoji(isDay),
        fontFamily: "CustomIcons",
      ),
      size: iconSize,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
