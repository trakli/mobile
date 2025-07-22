import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';

part 'subscription_dto.freezed.dart';
part 'subscription_dto.g.dart';

@freezed
class SubscriptionDto with _$SubscriptionDto {
  const factory SubscriptionDto({
    required String region,
    required String currency,
    @JsonKey(name: 'trial_days') required int trialDays,
    @JsonKey(name: 'free_plan_enabled') required bool freePlanEnabled,
    required List<PlanDto> plans,
  }) = _SubscriptionDto;

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDtoFromJson(json);

  const SubscriptionDto._();

  SubscriptionEntity toEntity() => SubscriptionEntity(
    region: region,
    currency: currency,
    trialDays: trialDays,
    freePlanEnabled: freePlanEnabled,
    plans: plans.map((e) => e.toEntity()).toList(),
  );
}

@freezed
class PlanDto with _$PlanDto {
  const factory PlanDto({
    required String id,
    required String name,
    required String interval,
    required List<String> features,
    required CtaDto cta,
    @JsonKey(name: 'price_cents') required int priceCents,
    required String currency,
    @JsonKey(name: 'trial_days') required int trialDays,
  }) = _PlanDto;

  factory PlanDto.fromJson(Map<String, dynamic> json) =>
      _$PlanDtoFromJson(json);

  const PlanDto._();

  PlanEntity toEntity() => PlanEntity(
    id: id,
    name: name,
    interval: interval,
    features: features,
    cta: cta.toEntity(),
    priceCents: priceCents,
    currency: currency,
    trialDays: trialDays,
  );
}

@freezed
class CtaDto with _$CtaDto {
  const factory CtaDto({
    required String text,
    @JsonKey(name: 'button_text') required String buttonText,
  }) = _CtaDto;

  factory CtaDto.fromJson(Map<String, dynamic> json) =>
      _$CtaDtoFromJson(json);

  const CtaDto._();

  CtaEntity toEntity() => CtaEntity(
    text: text,
    buttonText: buttonText,
  );
}
