import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository;

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit(_weatherRepository),
      child: const WeatherAppView(),
    );
  }
}

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

extension on Weather {
  /// This method added to [Weather] allows us to have a color
  /// for each [WeatherCondition] to use as background color.
  Color get toColor {
    switch (condition) {
      case WeatherCondition.clear:
        return Colors.yellow;
      case WeatherCondition.snowy:
        return Colors.lightBlueAccent;
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.rainy:
        return Colors.indigoAccent;
      case WeatherCondition.unknown:
        return Colors.cyan;
    }
  }
}
