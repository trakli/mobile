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
    );

Map<String, dynamic> _$$OnboardingEntityImplToJson(
        _$OnboardingEntityImpl instance) =>
    <String, dynamic>{
      'selectedCurrency': _$JsonConverterToJson<Map<String, dynamic>, Currency>(
          instance.selectedCurrency, const CurrencyConverter().toJson),
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
