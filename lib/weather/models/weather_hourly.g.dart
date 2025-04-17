// GENERATED CODE - DO NOT MODIFY BY HAND

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
          isDay: $checkedConvert('is_day',
              (v) => (v as List<dynamic>).map((e) => e as bool).toList()),
          condition: $checkedConvert(
              'condition',
              (v) => (v as List<dynamic>)
                  .map((e) => $enumDecode(_$WeatherConditionEnumMap, e))
                  .toList()),
          temperature: $checkedConvert(
              'temperature',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'isDay': 'is_day'},
    );

Map<String, dynamic> _$WeatherHourlyToJson(WeatherHourly instance) =>
    <String, dynamic>{
      'time': instance.time,
      'is_day': instance.isDay,
      'condition':
          instance.condition.map((e) => _$WeatherConditionEnumMap[e]!).toList(),
      'temperature': instance.temperature,
    };

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
