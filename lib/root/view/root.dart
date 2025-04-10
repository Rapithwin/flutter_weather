import 'package:bloc_weather/forecast/view/forecast_page.dart';
import 'package:bloc_weather/root/cubit/tab_cubit.dart';
import 'package:bloc_weather/saved/view/saved_page.dart';
import 'package:bloc_weather/weather/view/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((TabCubit cubit) => cubit.state.tab);
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: <Widget>[
          WeatherPage(),
          ForecastPage(),
          SavedPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _RootTabButton(
              groupValue: selectedTab,
              value: Tabs.current,
              icon: Icon(Icons.sunny),
            ),
            _RootTabButton(
              groupValue: selectedTab,
              value: Tabs.forecast,
              icon: Icon(Icons.calendar_month),
            ),
            _RootTabButton(
              groupValue: selectedTab,
              value: Tabs.saved,
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
    );
  }
}

class _RootTabButton extends StatelessWidget {
  const _RootTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final Tabs groupValue;
  final Tabs value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<TabCubit>().setTab(value),
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
      isSelected: value == groupValue,
    );
  }
}
