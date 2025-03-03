part of 'location_cubit.dart';

enum LocationStatus { initial, loading, success, failure }

extension LocationStatusX on LocationStatus {
  bool get isInitial => this == LocationStatus.initial;
  bool get isLoading => this == LocationStatus.loading;
  bool get isSuccess => this == LocationStatus.success;
  bool get isFailure => this == LocationStatus.failure;
}

@JsonSerializable()
final class LocationState extends Equatable {
  LocationState({
    this.status = LocationStatus.initial,
    List<Location>? location,
  }) : location = location ?? [];

  final LocationStatus status;
  final List<Location> location;

  factory LocationState.fromJson(Map<String, dynamic> json) =>
      _$LocationStateFromJson(json);

  Map<String, dynamic> toJson() => _$LocationStateToJson(this);

  LocationState copyWith({
    LocationStatus? status,
    List<Location>? location,
  }) {
    return LocationState(
      status: status ?? this.status,
      location: location ?? this.location,
    );
  }

  @override
  List<Object> get props => [status, location];
}
