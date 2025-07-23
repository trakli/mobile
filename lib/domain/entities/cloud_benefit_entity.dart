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

class BenefitEntity extends Equatable {
  final String title;
  final String description;

  const BenefitEntity({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

class CloudBenefitEntity extends Equatable {
  final OverviewEntity overview;
  final List<BenefitEntity> benefits;
  final int trialDays;

  const CloudBenefitEntity({
    required this.overview,
    required this.benefits,
    required this.trialDays,
  });

  @override
  List<Object?> get props => [overview, benefits, trialDays];
}
