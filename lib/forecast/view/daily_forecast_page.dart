import 'package:bloc_weather/forecast/cubit/daily_cubit.dart';
import 'package:bloc_weather/forecast/widgets/widgets.dart';
import 'package:bloc_weather/search/cubit/location_cubit.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  late double latitude;
  late double longitude;

  @override
  void initState() {
    // latitude = context.read<WeatherCubit>().state.
    // context.read<DailyCubit>().fetchDaily(latitude, longitude);
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
                  ),
              };
            },
          ),
        ));
  }
}
