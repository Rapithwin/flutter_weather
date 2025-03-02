import 'package:bloc/bloc.dart';
import 'package:bloc_weather/search/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    show WeatherRepository;

part 'location_state.dart';
part 'location_cubit.g.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit(this._weatherRepository) : super(LocationState());
  final WeatherRepository _weatherRepository;

  Future<void> fetchLocation(String? city) async {
    if (city == null || city.isEmpty) return;

    emit(state.copyWith(status: LocationStatus.loading));

    try {
      final List<Location> location = Location.fromRepository(
        await _weatherRepository.getLocation(city),
      );

      emit(state.copyWith(status: LocationStatus.success, location: location));
    } on Exception {
      emit(state.copyWith(status: LocationStatus.failure));
    }
  }
}
