import 'package:bloc_weather/forecast/models/daily.dart';
import 'package:bloc_weather/weather/models/weather.dart';
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
    return const Placeholder();
  }
}
