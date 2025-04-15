// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'weather_hourly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherHourly _$WeatherHourlyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WeatherHourly',
      json,
      ($checkedConvert) {
        final val = WeatherHourly(
          time: $checkedConvert('time', (v) => DateTime.parse(v as String)),
          temperature:
              $checkedConvert('temperature', (v) => (v as num).toDouble()),
          isDay: $checkedConvert('is_day', (v) => (v as num).toInt()),
          weatherCode:
              $checkedConvert('weathercode', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {'isDay': 'is_day', 'weatherCode': 'weathercode'},
    );
