import 'package:bloc_weather/forecast/cubit/daily_cubit.dart';
import 'package:bloc_weather/forecast/models/daily.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:bloc_weather/weather/extensions/extensions.dart';
import 'package:bloc_weather/weather/models/weather.dart';
import 'package:bloc_weather/weather/widgets/widgets.dart' show WeatherIcon;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForecastSuccess extends StatefulWidget {
  const ForecastSuccess({
    super.key,
    required this.units,
    required this.daily,
    required this.onRefresh,
  });
  final Units units;
  final WeatherDaily daily;
  final AsyncValueGetter<void> onRefresh;

  @override
  State<ForecastSuccess> createState() => _ForecastSuccessState();
}

class _ForecastSuccessState extends State<ForecastSuccess> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                height: size.height / 2.5,
                child: ListView.builder(
                  itemCount: widget.daily.time.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            spacing: 15,
                            children: <Widget>[
                              Text(widget.daily.time[index]),
                              WeatherIcon(
                                condition: widget.daily.condition[index],
                                isDay: true,
                                iconSize: 30,
                              ),
                              Text(
                                widget.daily.temperatureMax[index].toString(),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: 15,
                            children: <Widget>[
                              Text(
                                widget.daily.temperatureMin[index].toString(),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              WeatherIcon(
                                condition: widget.daily.condition[index],
                                isDay: false,
                                iconSize: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    IconData(
                                      widget.daily.windDirection[index]
                                          .windDirectionToIcon(),
                                      fontFamily: "CustomIcons",
                                    ),
                                    size: 30,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                  Text(
                                    widget.daily.windSpeed[index]
                                        .formattedSpeed(widget.units),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
