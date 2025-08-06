// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionDtoImpl _$$SubscriptionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionDtoImpl(
      overview: OverviewDto.fromJson(json['overview'] as Map<String, dynamic>),
      region: json['region'] as String,
      currency: json['currency'] as String,
      trialDays: (json['trial_days'] as num).toInt(),
      freePlanEnabled: json['free_plan_enabled'] as bool,
      plans: (json['plans'] as List<dynamic>)
          .map((e) => PlanDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SubscriptionDtoImplToJson(
        _$SubscriptionDtoImpl instance) =>
    <String, dynamic>{
      'overview': instance.overview.toJson(),
      'region': instance.region,
      'currency': instance.currency,
      'trial_days': instance.trialDays,
      'free_plan_enabled': instance.freePlanEnabled,
      'plans': instance.plans.map((e) => e.toJson()).toList(),
    };

_$OverviewDtoImpl _$$OverviewDtoImplFromJson(Map<String, dynamic> json) =>
    _$OverviewDtoImpl(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$OverviewDtoImplToJson(_$OverviewDtoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

_$PlanDtoImpl _$$PlanDtoImplFromJson(Map<String, dynamic> json) =>
    _$PlanDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      interval: json['interval'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      cta: CtaDto.fromJson(json['cta'] as Map<String, dynamic>),
      price: parseAmount(json['price']),
      priceFormatted: json['price_formatted'] as String,
    );

Map<String, dynamic> _$$PlanDtoImplToJson(_$PlanDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'interval': instance.interval,
      'features': instance.features,
      'cta': instance.cta.toJson(),
      'price': instance.price,
      'price_formatted': instance.priceFormatted,
    };

_$CtaDtoImpl _$$CtaDtoImplFromJson(Map<String, dynamic> json) => _$CtaDtoImpl(
      text: json['text'] as String,
      buttonText: json['button_text'] as String,
    );

Map<String, dynamic> _$$CtaDtoImplToJson(_$CtaDtoImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'button_text': instance.buttonText,
    };
