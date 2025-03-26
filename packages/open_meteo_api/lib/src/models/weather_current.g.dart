// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'weather_current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherCurrent _$WeatherCurrentFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WeatherCurrent',
      json,
      ($checkedConvert) {
        final val = WeatherCurrent(
          temperature:
              $checkedConvert('temperature', (v) => (v as num).toDouble()),
          weatherCode:
              $checkedConvert('weathercode', (v) => (v as num).toDouble()),
          isDay: $checkedConvert('is_day', (v) => (v as num).toInt()),
          windSpeed: $checkedConvert('windspeed', (v) => (v as num).toDouble()),
          feelsLike: $checkedConvert(
              'apparent_temperature', (v) => (v as num).toDouble()),
          humidity: $checkedConvert(
              'relative_humidity_2m', (v) => (v as num).toInt()),
          visibility: $checkedConvert('visibility', (v) => (v as num).toInt()),
          windDirection: $checkedConvert(
              'wind_direction_10m', (v) => (v as num).toDouble()),
        );
        return val;
      },
      fieldKeyMap: const {
        'weatherCode': 'weathercode',
        'isDay': 'is_day',
        'windSpeed': 'windspeed',
        'feelsLike': 'apparent_temperature',
        'humidity': 'relative_humidity_2m',
        'windDirection': 'wind_direction_10m'
      },
    );
