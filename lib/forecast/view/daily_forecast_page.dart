import 'package:bloc_weather/forecast/cubit/daily_cubit.dart';
import 'package:bloc_weather/forecast/widgets/widgets.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  @override
  void initState() {
    final dailyCubit = context.read<DailyCubit>();
    if (dailyCubit.state.status != ForecastStatus.success) {
      final weather = context.read<WeatherCubit>().state.weather;
      if (weather.latitude != null && weather.longitude != null) {
        dailyCubit.fetchDaily(weather.latitude, weather.longitude);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "7-day Forecast",
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        body: Center(
          child: BlocBuilder<DailyCubit, DailyState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return switch (state.status) {
                ForecastStatus.initial => const ForecastEmpty(),
                ForecastStatus.loading => const ForecastLoading(),
                ForecastStatus.failure => const ForecastError(),
                ForecastStatus.success => ForecastSuccess(
                    daily: state.daily,
                    units: state.units,
                    onRefresh: () {
                      final weather =
                          context.read<WeatherCubit>().state.weather;
                      return context
                          .read<DailyCubit>()
                          .refreshDaily(weather.latitude, weather.longitude);
                    },
                  ),
              };
            },
          ),
        ));
  }
}
