import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/data/datasources/core/amount_parser.dart';

part 'subscription_dto.freezed.dart';
part 'subscription_dto.g.dart';

@freezed
class SubscriptionDto with _$SubscriptionDto {
  const factory SubscriptionDto({
    required OverviewDto overview,
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
        overview: overview.toEntity(),
        region: region,
        currency: currency,
        trialDays: trialDays,
        freePlanEnabled: freePlanEnabled,
        plans: plans.map((e) => e.toEntity()).toList(),
      );
}

@freezed
class OverviewDto with _$OverviewDto {
  const factory OverviewDto({
    required String title,
    required String description,
  }) = _OverviewDto;

  factory OverviewDto.fromJson(Map<String, dynamic> json) =>
      _$OverviewDtoFromJson(json);

  const OverviewDto._();

  OverviewEntity toEntity() => OverviewEntity(
        title: title,
        description: description,
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
    @JsonKey(fromJson: parseAmount) required double price,
    @JsonKey(name: 'price_formatted') required String priceFormatted,
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
        price: price,
        priceFormatted: priceFormatted,
      );
}

@freezed
class CtaDto with _$CtaDto {
  const factory CtaDto({
    required String text,
    @JsonKey(name: 'button_text') required String buttonText,
  }) = _CtaDto;

  factory CtaDto.fromJson(Map<String, dynamic> json) => _$CtaDtoFromJson(json);

  const CtaDto._();

  CtaEntity toEntity() => CtaEntity(
        text: text,
        buttonText: buttonText,
      );
}
