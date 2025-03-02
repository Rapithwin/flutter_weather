import 'package:bloc_weather/search/cubit/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationsList extends StatelessWidget {
  const LocationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {},
    );
  }
}

class LocationsError extends StatelessWidget {
  const LocationsError({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "Something went wrong",
      style: theme.textTheme.headlineSmall,
    );
  }
}

class LocationsLoading extends StatelessWidget {
  const LocationsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
