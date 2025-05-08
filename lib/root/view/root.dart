import 'package:bloc_weather/forecast/view/daily_forecast_page.dart';
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
      backgroundColor: theme.colorScheme.primary,
      body: IndexedStack(
        index: selectedTab.index,
        children: <Widget>[
          WeatherPage(),
          ForecastPage(),
          SavedPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.colorScheme.primary,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _RootTabButton(
              groupValue: selectedTab,
              value: Tabs.current,
              icon: Icon(Icons.wb_sunny_outlined),
              selectedIcon: Icon(Icons.wb_sunny),
            ),
            _RootTabButton(
              groupValue: selectedTab,
              value: Tabs.forecast,
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month),
            ),
            _RootTabButton(
              groupValue: selectedTab,
              value: Tabs.saved,
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
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
    required this.selectedIcon,
  });

  final Tabs groupValue;
  final Tabs value;
  final Widget icon;
  final Widget selectedIcon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<TabCubit>().setTab(value),
      iconSize: 32,
      color: Theme.of(context).colorScheme.onSecondary,
      icon: icon,
      isSelected: value == groupValue,
      selectedIcon: selectedIcon,
    );
  }
}
