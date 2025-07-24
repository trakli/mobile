import 'package:equatable/equatable.dart';

class CtaEntity extends Equatable {
  final String text;
  final String buttonText;

  const CtaEntity({
    required this.text,
    required this.buttonText,
  });

  @override
  List<Object?> get props => [text, buttonText];
}

class PlanEntity extends Equatable {
  final String id;
  final String name;
  final String interval;
  final List<String> features;
  final CtaEntity cta;
  final int priceCents;
  final String currency;
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
}

class SubscriptionEntity extends Equatable {
  final String region;
  final String currency;
  final int trialDays;
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
}
