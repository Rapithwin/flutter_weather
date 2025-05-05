// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

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
          minTemperature: $checkedConvert(
              'temperature_2m_min',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          maxTemperature: $checkedConvert(
              'temperature_2m_max',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          windSpeed: $checkedConvert(
              'wind_speed_10m_max',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          windDirection: $checkedConvert(
              'wind_direction_10m_dominant',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          weatherCode: $checkedConvert(
              'weathercode',
              (v) =>
                  (v as List<dynamic>).map((e) => (e as num).toInt()).toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'minTemperature': 'temperature_2m_min',
        'maxTemperature': 'temperature_2m_max',
        'windSpeed': 'wind_speed_10m_max',
        'windDirection': 'wind_direction_10m_dominant',
        'weatherCode': 'weathercode'
      },
    );
