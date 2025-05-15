// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyState _$DailyStateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'DailyState',
      json,
      ($checkedConvert) {
        final val = DailyState(
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$ForecastStatusEnumMap, v) ??
                  ForecastStatus.initial),
          daily: $checkedConvert(
              'daily',
              (v) => v == null
                  ? null
                  : WeatherDaily.fromJson(v as Map<String, dynamic>)),
          units: $checkedConvert('units',
              (v) => $enumDecodeNullable(_$UnitsEnumMap, v) ?? Units.metric),
        );
        return val;
      },
    );

Map<String, dynamic> _$DailyStateToJson(DailyState instance) =>
    <String, dynamic>{
      'status': _$ForecastStatusEnumMap[instance.status]!,
      'daily': instance.daily.toJson(),
      'units': _$UnitsEnumMap[instance.units]!,
    };

const _$ForecastStatusEnumMap = {
  ForecastStatus.initial: 'initial',
  ForecastStatus.loading: 'loading',
  ForecastStatus.success: 'success',
  ForecastStatus.failure: 'failure',
};

const _$UnitsEnumMap = {
  Units.metric: 'metric',
  Units.imperial: 'imperial',
};
