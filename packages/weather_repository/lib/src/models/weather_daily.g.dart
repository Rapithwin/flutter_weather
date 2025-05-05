// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDaily _$WeatherDailyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WeatherDaily',
      json,
      ($checkedConvert) {
        final val = WeatherDaily(
          time: $checkedConvert('time',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          temperatureMin: $checkedConvert(
              'temperature_min',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          temperatureMax: $checkedConvert(
              'temperature_max',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          windSpeed: $checkedConvert(
              'wind_speed',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          windDirection: $checkedConvert('wind_direction',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          condition: $checkedConvert(
              'condition',
              (v) => (v as List<dynamic>)
                  .map((e) => $enumDecode(_$WeatherConditionEnumMap, e))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'temperatureMin': 'temperature_min',
        'temperatureMax': 'temperature_max',
        'windSpeed': 'wind_speed',
        'windDirection': 'wind_direction'
      },
    );

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.mainlyClear: 'mainlyClear',
  WeatherCondition.rainy: 'rainy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.snowy: 'snowy',
  WeatherCondition.unknown: 'unknown',
  WeatherCondition.partlyCloudy: 'partlyCloudy',
  WeatherCondition.foggy: 'foggy',
  WeatherCondition.thunderstorm: 'thunderstorm',
};
