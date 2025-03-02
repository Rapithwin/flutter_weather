import 'package:bloc/bloc.dart';
import 'package:bloc_weather/search/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_state.dart';
part 'location_cubit.g.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());
}
