import 'package:flutter/material.dart';

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
