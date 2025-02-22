import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:bloc_weather/weather/view/weather_page.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

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
    final seedColor = context.select(
      (WeatherCubit cubit) => cubit.state.weather.toColor,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: seedColor, primary: seedColor),
        textTheme: GoogleFonts.rajdhaniTextTheme(),
      ),
      home: WeatherPage(),
    );
  }
}

extension on Weather {
  /// This method added to [Weather] allows us to have a color
  /// for each [WeatherCondition] to use as background color.
  Color get toColor {
    switch (condition) {
      case WeatherCondition.clear:
        return Colors.lightBlue;
      case WeatherCondition.snowy:
        return const Color.fromARGB(255, 156, 221, 252);
      case WeatherCondition.cloudy:
        return Colors.blueGrey;
      case WeatherCondition.rainy:
        return const Color.fromARGB(255, 60, 75, 158);
      case WeatherCondition.unknown:
        return Colors.cyan;
    }
  }
}
