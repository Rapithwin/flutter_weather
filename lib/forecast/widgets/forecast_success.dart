import 'package:bloc_weather/forecast/models/daily.dart';
import 'package:bloc_weather/weather/extensions/extensions.dart';
import 'package:bloc_weather/weather/models/weather.dart';
import 'package:bloc_weather/weather/widgets/widgets.dart' show WeatherIcon;
import 'package:flutter/material.dart';

class ForecastSuccess extends StatelessWidget {
  const ForecastSuccess({
    super.key,
    required this.units,
    required this.daily,
  });
  final Units units;
  final WeatherDaily daily;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: size.height / 2.5,
        child: ListView.builder(
          itemCount: daily.time.length,
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
                      Text(daily.time[index]),
                      WeatherIcon(
                        condition: daily.condition[index],
                        isDay: true,
                        iconSize: 30,
                      ),
                      Text(
                        daily.temperatureMax[index].toString(),
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
                        daily.temperatureMin[index].toString(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      WeatherIcon(
                        condition: daily.condition[index],
                        isDay: false,
                        iconSize: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            IconData(
                              daily.windDirection[index].windDirectionToIcon(),
                              fontFamily: "CustomIcons",
                            ),
                            size: 30,
                            color: theme.colorScheme.onPrimary,
                          ),
                          Text(
                            daily.windSpeed[index].formattedSpeed(units),
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
    );
  }
}
