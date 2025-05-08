import 'package:flutter/material.dart';

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
      // body: ListView.builder(
      //   itemBuilder: (context, index) {
      //     return Container();
      //   },
      // ),
    );
  }
}
