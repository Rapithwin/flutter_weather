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
          time: $checkedConvert('time',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          temperature: $checkedConvert(
              'temperature',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          isDay: $checkedConvert(
              'is_day',
              (v) =>
                  (v as List<dynamic>).map((e) => (e as num).toInt()).toList()),
          weatherCode: $checkedConvert(
              'weathercode',
              (v) =>
                  (v as List<dynamic>).map((e) => (e as num).toInt()).toList()),
        );
        return val;
      },
      fieldKeyMap: const {'isDay': 'is_day', 'weatherCode': 'weathercode'},
    );
