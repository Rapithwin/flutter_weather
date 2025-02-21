import 'dart:ffi';

import 'package:bloc_weather/settings/settings.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:bloc_weather/weather/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../search/view/search_page.dart';

/// Uses [BlocProvider] in order to provide an instance of the
/// [WeatherCubit] to the widget tree.
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(SettingsPage.route());
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return switch (state.status) {
              WeatherStatus.initial => const WeatherEmpty(),
              WeatherStatus.loading => const WeatherLoading(),
              WeatherStatus.failure => const WeatherError(),
              WeatherStatus.success => WeatherPopulated(
                  weather: state.weather,
                  units: state.temperatureUnits,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather();
                  },
                ),
            };
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route());
          if (!context.mounted) return;
          await context.read<WeatherCubit>().fetchWeather(city);
        },
        child: const Icon(
          Icons.search,
          semanticLabel: "search",
        ),
      ),
    );
  }
}
