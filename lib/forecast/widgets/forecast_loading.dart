import 'package:flutter/material.dart';

class ForecastLoading extends StatelessWidget {
  const ForecastLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: CircularProgressIndicator(
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}
