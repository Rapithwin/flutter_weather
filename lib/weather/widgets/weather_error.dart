import 'package:flutter/material.dart';

/// This screen will display if there is an error.
class WeatherError extends StatelessWidget {
  const WeatherError({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "🙈",
          style: TextStyle(fontSize: 64),
        ),
        Text(
          "Something went wrong!",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
