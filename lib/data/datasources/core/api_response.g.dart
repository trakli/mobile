// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl _$$ApiResponseImplFromJson(Map<String, dynamic> json) =>
    _$ApiResponseImpl(
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      data: json['data'],
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$ApiResponseImplToJson(_$ApiResponseImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
      'success': instance.success,
    };
