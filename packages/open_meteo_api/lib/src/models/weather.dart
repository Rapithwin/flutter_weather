import 'package:json_annotation/json_annotation.dart';
part 'weather.g.dart';

@JsonSerializable()

/// [Weather] model containing all the info returnted by
/// the API.
class Weather {
  final double temperature;
  // specifies that the JSON key corresponding to the weatherCode
  // property in the Dart model is "weathercode".
  @JsonKey(name: "weathercode")
  final double weatherCode;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Weather({
    required this.temperature,
    required this.weatherCode,
  });
}
