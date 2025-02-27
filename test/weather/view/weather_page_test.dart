import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_weather/weather/cubit/weather_cubit.dart';
import 'package:bloc_weather/weather/models/models.dart';
import 'package:bloc_weather/weather/view/weather_page.dart';
import 'package:bloc_weather/weather/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;
import 'package:bloc_weather/weather/weather.dart';

import '../../helpers/hydrated_bloc.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeatherCubit extends MockCubit<WeatherState>
    implements WeatherCubit {}

void main() {
  initHydratedStorage();

  group("weatherPage", () {
    final weather = Weather(
      location: "London",
      temperature: Temperature(value: 4.2),
      condition: WeatherCondition.cloudy,
      isDay: true,
      windSpeed: 12.2,
      lastUpdated: DateTime(2020),
    );

    late WeatherCubit weatherCubit;

    setUp(() {
      weatherCubit = MockWeatherCubit();
    });

    testWidgets(
      "renders WeatherLoading for WeatherStatus.loading",
      (tester) async {
        when(() => weatherCubit.state).thenReturn(
          WeatherState(
            status: WeatherStatus.loading,
          ),
        );
        await tester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: MaterialApp(
              home: WeatherPage(),
            ),
          ),
        );
        // find.byType(WeatherLoading) is a way to locate
        // widgets of a specific type (in this case, a widget
        // of type WeatherLoading).
        //
        // findsOneWidget is a matcher that checks that exactly
        // one instance of the widget is found in the widget tree.
        expect(find.byType(WeatherLoading), findsOneWidget);
      },
    );

    testWidgets(
      "renders WeatherPopulated for WeatherStatus.success",
      (tester) async {
        when(() => weatherCubit.state).thenReturn(
          WeatherState(status: WeatherStatus.success),
        );
        await tester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: MaterialApp(
              home: WeatherPage(),
            ),
          ),
        );
        expect(find.byType(WeatherPopulated), findsOneWidget);
      },
    );
  });
}
