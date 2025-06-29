// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingModelImpl _$$OnboardingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingModelImpl(
      selectedCurrency: _$JsonConverterFromJson<Map<String, dynamic>, Currency>(
          json['selectedCurrency'], const CurrencyConverter().fromJson),
      defaultGroup: json['defaultGroup'] as String?,
    );

Map<String, dynamic> _$$OnboardingModelImplToJson(
        _$OnboardingModelImpl instance) =>
    <String, dynamic>{
      'selectedCurrency': _$JsonConverterToJson<Map<String, dynamic>, Currency>(
          instance.selectedCurrency, const CurrencyConverter().toJson),
      'defaultGroup': instance.defaultGroup,
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
