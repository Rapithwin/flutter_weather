import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:bloc_weather/weather/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This page allows users to update their preferences for
/// the temperature units.
class SettingsPage extends StatelessWidget {
  const SettingsPage._();

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SettingsPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          BlocBuilder<WeatherCubit, WeatherState>(
            //Without buildWhen, the widget would rebuild every time
            // any part of the state changes (even if temperatureUnits didn't change).
            // This improves performance by avoiding unnecessary UI updates.
            buildWhen: (previous, current) => previous.units != current.units,
            builder: (context, state) {
              return ListTile(
                title: const Text("Temperature Units"),
                isThreeLine: true,
                subtitle: const Text(
                  "User metric measurements for temperature units",
                ),
                trailing: Switch(
                  value: state.units.isMetric,
                  onChanged: (_) => context.read<WeatherCubit>().toggleUnits(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
