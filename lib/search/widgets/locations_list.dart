import 'package:bloc_weather/search/cubit/location_cubit.dart';
import 'package:bloc_weather/search/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationsList extends StatelessWidget {
  const LocationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return switch (state.status) {
          LocationStatus.initial => const LocationsInitial(),
          LocationStatus.loading => const LocationsLoading(),
          LocationStatus.failure => const LocationsError(),
          LocationStatus.success => LocationsListBuilder(
              locations: state.location,
            )
        };
      },
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

class LocationsInitial extends StatelessWidget {
  const LocationsInitial({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "Search for a city.",
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

class LocationsListBuilder extends StatelessWidget {
  const LocationsListBuilder({super.key, required this.locations});

  final List<Location> locations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
        );
      },
    );
  }
}
