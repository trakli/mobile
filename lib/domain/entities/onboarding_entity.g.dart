// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingEntityImpl _$$OnboardingEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingEntityImpl(
      selectedCurrency: _$JsonConverterFromJson<Map<String, dynamic>, Currency>(
          json['selectedCurrency'], const CurrencyConverter().fromJson),
      defaultGroup: json['defaultGroup'] as String?,
      editWalletAmount: json['editWalletAmount'] as bool?,
    );

Map<String, dynamic> _$$OnboardingEntityImplToJson(
        _$OnboardingEntityImpl instance) =>
    <String, dynamic>{
      'selectedCurrency': _$JsonConverterToJson<Map<String, dynamic>, Currency>(
          instance.selectedCurrency, const CurrencyConverter().toJson),
      'defaultGroup': instance.defaultGroup,
      'editWalletAmount': instance.editWalletAmount,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
