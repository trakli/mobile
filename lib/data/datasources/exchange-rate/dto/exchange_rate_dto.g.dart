// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExchangeRateDtoImpl _$$ExchangeRateDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ExchangeRateDtoImpl(
      provider: json['provider'] as String,
      baseCode: json['base_code'] as String,
      rates: (json['rates'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      timeLastUpdated:
          dateTimeFromUnixSeconds(json['time_last_update_unix'] as num),
      timeNextUpdated:
          dateTimeFromUnixSeconds(json['time_next_update_unix'] as num),
    );

Map<String, dynamic> _$$ExchangeRateDtoImplToJson(
        _$ExchangeRateDtoImpl instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'base_code': instance.baseCode,
      'rates': instance.rates,
      'time_last_update_unix': dateTimeToUnixSeconds(instance.timeLastUpdated),
      'time_next_update_unix': dateTimeToUnixSeconds(instance.timeNextUpdated),
    };
