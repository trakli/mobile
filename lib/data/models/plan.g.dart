// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanEntity _$PlanEntityFromJson(Map<String, dynamic> json) => PlanEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      interval: json['interval'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      cta: CtaEntity.fromJson(json['cta'] as Map<String, dynamic>),
      priceCents: (json['price_cents'] as num).toInt(),
      currency: json['currency'] as String,
      trialDays: (json['trial_days'] as num).toInt(),
    );

Map<String, dynamic> _$PlanEntityToJson(PlanEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'interval': instance.interval,
      'features': instance.features,
      'cta': instance.cta.toJson(),
      'price_cents': instance.priceCents,
      'currency': instance.currency,
      'trial_days': instance.trialDays,
    };

CtaEntity _$CtaEntityFromJson(Map<String, dynamic> json) => CtaEntity(
      text: json['text'] as String,
      buttonText: json['button_text'] as String,
    );

Map<String, dynamic> _$CtaEntityToJson(CtaEntity instance) => <String, dynamic>{
      'text': instance.text,
      'button_text': instance.buttonText,
    };

SubscriptionEntity _$SubscriptionEntityFromJson(Map<String, dynamic> json) =>
    SubscriptionEntity(
      region: json['region'] as String,
      currency: json['currency'] as String,
      trialDays: (json['trial_days'] as num).toInt(),
      freePlanEnabled: json['free_plan_enabled'] as bool,
      plans: (json['plans'] as List<dynamic>)
          .map((e) => PlanEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscriptionEntityToJson(SubscriptionEntity instance) =>
    <String, dynamic>{
      'region': instance.region,
      'currency': instance.currency,
      'trial_days': instance.trialDays,
      'free_plan_enabled': instance.freePlanEnabled,
      'plans': instance.plans.map((e) => e.toJson()).toList(),
    };
