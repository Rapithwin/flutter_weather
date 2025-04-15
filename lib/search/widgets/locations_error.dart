import 'package:flutter/material.dart';

class LocationsError extends StatelessWidget {
  const LocationsError({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      "Something went wrong",
      style: theme.textTheme.headlineSmall?.copyWith(
        color: Colors.black,
      ),
    );
  }
}
