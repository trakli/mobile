// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_state_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SyncStateDtoImpl _$$SyncStateDtoImplFromJson(Map<String, dynamic> json) =>
    _$SyncStateDtoImpl(
      state: json['state'] as String,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$SyncStateDtoImplToJson(_$SyncStateDtoImpl instance) =>
    <String, dynamic>{
      'state': instance.state,
      'error': instance.error,
    };
