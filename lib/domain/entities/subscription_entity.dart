import 'package:equatable/equatable.dart';

class OverviewEntity extends Equatable {
  final String title;
  final String description;

  const OverviewEntity({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}


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
  final double price;
  final String priceFormatted;


  const PlanEntity({
    required this.id,
    required this.name,
    required this.interval,
    required this.features,
    required this.cta,
    required this.price,
    required this.priceFormatted,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    interval,
    features,
    cta,
    price,
    priceFormatted,
  ];
}

class SubscriptionEntity extends Equatable {
  final OverviewEntity overview;
  final String region;
  final String currency;
  final int trialDays;
  final bool freePlanEnabled;
  final List<PlanEntity> plans;

  const SubscriptionEntity({
    required this.overview,
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
