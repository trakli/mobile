import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

@JsonSerializable()
class PlanEntity extends Equatable {
  final String id;
  final String name;
  final String interval;
  final List<String> features;
  final CtaEntity cta;
  @JsonKey(name: 'price_cents')
  final int priceCents;
  final String currency;
  @JsonKey(name: 'trial_days')
  final int trialDays;

  const PlanEntity({
    required this.id,
    required this.name,
    required this.interval,
    required this.features,
    required this.cta,
    required this.priceCents,
    required this.currency,
    required this.trialDays,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        interval,
        features,
        cta,
        priceCents,
        currency,
        trialDays,
      ];

  factory PlanEntity.fromJson(Map<String, dynamic> json) =>
      _$PlanEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PlanEntityToJson(this);
}

@JsonSerializable()
class CtaEntity extends Equatable {
  final String text;
  @JsonKey(name: 'button_text')
  final String buttonText;

  const CtaEntity({
    required this.text,
    required this.buttonText,
  });

  @override
  List<Object?> get props => [text, buttonText];

  factory CtaEntity.fromJson(Map<String, dynamic> json) =>
      _$CtaEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CtaEntityToJson(this);
}

@JsonSerializable()
class SubscriptionEntity extends Equatable {
  final String region;
  final String currency;
  @JsonKey(name: 'trial_days')
  final int trialDays;
  @JsonKey(name: 'free_plan_enabled')
  final bool freePlanEnabled;
  final List<PlanEntity> plans;

  const SubscriptionEntity({
    required this.region,
    required this.currency,
    required this.trialDays,
    required this.freePlanEnabled,
    required this.plans,
  });

  @override
  List<Object?> get props => [
        region,
        currency,
        trialDays,
        freePlanEnabled,
        plans,
      ];

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionEntityToJson(this);
}
