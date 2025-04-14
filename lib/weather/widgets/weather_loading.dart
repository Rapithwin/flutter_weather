import 'package:flutter/material.dart';

class WeatherLoading extends StatelessWidget {
  const WeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "⛅",
          style: TextStyle(fontSize: 64),
        ),
        Text(
          "Loading...",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.black,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        )
      ],
    );
  }
}
