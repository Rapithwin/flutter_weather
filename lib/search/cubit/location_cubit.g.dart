// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationState _$LocationStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LocationState',
      json,
      ($checkedConvert) {
        final val = LocationState(
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$LocationStatusEnumMap, v) ??
                  LocationStatus.initial),
          location: $checkedConvert(
              'location',
              (v) => v == null
                  ? null
                  : Location.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$LocationStateToJson(LocationState instance) =>
    <String, dynamic>{
      'status': _$LocationStatusEnumMap[instance.status]!,
      'location': instance.location.toJson(),
    };

const _$LocationStatusEnumMap = {
  LocationStatus.initial: 'initial',
  LocationStatus.loading: 'loading',
  LocationStatus.success: 'success',
  LocationStatus.failure: 'failure',
};
