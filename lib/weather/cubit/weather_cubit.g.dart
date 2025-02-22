// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherState _$WeatherStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'WeatherState',
      json,
      ($checkedConvert) {
        final val = WeatherState(
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$WeatherStatusEnumMap, v) ??
                  WeatherStatus.initial),
          units: $checkedConvert('units',
              (v) => $enumDecodeNullable(_$UnitsEnumMap, v) ?? Units.metric),
        );
        return val;
      },
    );

Map<String, dynamic> _$WeatherStateToJson(WeatherState instance) =>
    <String, dynamic>{
      'status': _$WeatherStatusEnumMap[instance.status]!,
      'units': _$UnitsEnumMap[instance.units]!,
    };

const _$WeatherStatusEnumMap = {
  WeatherStatus.initial: 'initial',
  WeatherStatus.loading: 'loading',
  WeatherStatus.success: 'success',
  WeatherStatus.failure: 'failure',
};

const _$UnitsEnumMap = {
  Units.metric: 'metric',
  Units.imperial: 'imperial',
};
