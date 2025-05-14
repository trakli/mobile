// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateUserResponseDtoImpl _$$CreateUserResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateUserResponseDtoImpl(
      accessToken: json['token'] as String,
      user: json['user'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$CreateUserResponseDtoImplToJson(
        _$CreateUserResponseDtoImpl instance) =>
    <String, dynamic>{
      'token': instance.accessToken,
      'user': instance.user,
    };
