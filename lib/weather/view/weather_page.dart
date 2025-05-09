import 'package:bloc_weather/settings/settings.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:bloc_weather/weather/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Uses [BlocProvider] in order to provide an instance of the
/// [WeatherCubit] to the widget tree.
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = context.read<WeatherCubit>().state.status;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: status != WeatherStatus.success
          ? AppBar(
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
            )
          : null,
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            return switch (state.status) {
              WeatherStatus.initial => const WeatherEmpty(),
              WeatherStatus.loading => const WeatherLoading(),
              WeatherStatus.failure => const WeatherError(),
              WeatherStatus.success => WeatherPopulated(
                  weather: state.weather,
                  hourly: state.hourly,
                  units: state.units,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather(
                        state.weather.latitude, state.weather.longitude);
                  },
                ),
            };
          },
        ),
      ),
    );
  }
}
