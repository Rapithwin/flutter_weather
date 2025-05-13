import 'package:bloc_weather/forecast/models/daily.dart';
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
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: size.height / 2,
        child: ListView.builder(
          itemCount: daily.time.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  WeatherIcon(
                    condition: daily.condition[index],
                    isDay: true,
                    iconSize: 30,
                  ),
                  Text("info"),
                  Text("info"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
