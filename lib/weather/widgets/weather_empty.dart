import 'package:flutter/material.dart';

/// This screen will show when there is no data to display
/// because the user has not yet selected a city.
class WeatherEmpty extends StatelessWidget {
  const WeatherEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "🏙️",
          style: TextStyle(fontSize: 64),
        ),
        Text(
          "Please Select a City!",
          style: theme.textTheme.headlineSmall,
        )
      ],
    );
  }
}
