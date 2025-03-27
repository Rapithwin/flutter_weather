// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Weather',
      json,
      ($checkedConvert) {
        final val = Weather(
          location: $checkedConvert('location', (v) => v as String),
          temperature:
              $checkedConvert('temperature', (v) => (v as num).toDouble()),
          condition: $checkedConvert(
              'condition', (v) => $enumDecode(_$WeatherConditionEnumMap, v)),
          isDay: $checkedConvert('is_day', (v) => v as bool),
          windSpeed:
              $checkedConvert('wind_speed', (v) => (v as num).toDouble()),
          feelsLike:
              $checkedConvert('feels_like', (v) => (v as num).toDouble()),
          humidity: $checkedConvert('humidity', (v) => (v as num).toInt()),
          visibility: $checkedConvert('visibility', (v) => (v as num).toInt()),
          windDirection: $checkedConvert('wind_direction', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'isDay': 'is_day',
        'windSpeed': 'wind_speed',
        'feelsLike': 'feels_like',
        'windDirection': 'wind_direction'
      },
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'condition': _$WeatherConditionEnumMap[instance.condition]!,
      'is_day': instance.isDay,
      'wind_speed': instance.windSpeed,
      'feels_like': instance.feelsLike,
      'humidity': instance.humidity,
      'visibility': instance.visibility,
      'wind_direction': instance.windDirection,
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
};
