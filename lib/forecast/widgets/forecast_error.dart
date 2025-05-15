import 'package:flutter/material.dart';

class ForecastError extends StatelessWidget {
  const ForecastError({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Text(
        "Something went wrong",
        style: theme.textTheme.displayMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
