// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseDtoImpl _$$AuthResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResponseDtoImpl(
      accessToken: json['token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expireTn: (json['expires_in'] as num?)?.toInt(),
      tokenType: json['token_type'] as String?,
      user: json['user'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$AuthResponseDtoImplToJson(
        _$AuthResponseDtoImpl instance) =>
    <String, dynamic>{
      'token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expireTn,
      'token_type': instance.tokenType,
      'user': instance.user,
    };
