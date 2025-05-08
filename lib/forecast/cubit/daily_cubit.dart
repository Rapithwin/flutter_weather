import 'package:bloc/bloc.dart';
import 'package:bloc_weather/forecast/models/daily.dart';
import 'package:bloc_weather/weather/weather.dart';
import 'package:equatable/equatable.dart';

part 'daily_state.dart';

class DailyCubit extends Cubit<DailyState> {
  DailyCubit() : super(DailyInitial());
}
