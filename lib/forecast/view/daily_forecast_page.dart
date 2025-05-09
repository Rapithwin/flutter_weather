import 'package:bloc_weather/forecast/cubit/daily_cubit.dart';
import 'package:bloc_weather/forecast/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

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
