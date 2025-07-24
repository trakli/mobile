import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/cloud_benefit_entity.dart';

part 'cloud_benefit_dto.freezed.dart';
part 'cloud_benefit_dto.g.dart';

@freezed
class CloudBenefitDto with _$CloudBenefitDto {
  const factory CloudBenefitDto({
    required OverviewDto overview,
    required List<BenefitDto> benefits,
    @JsonKey(name: 'trial_days') required int trialDays,
  }) = _CloudBenefitDto;

  factory CloudBenefitDto.fromJson(Map<String, dynamic> json) =>
      _$CloudBenefitDtoFromJson(json);

  const CloudBenefitDto._();

  CloudBenefitEntity toEntity() => CloudBenefitEntity(
    overview: overview.toEntity(),
    benefits: benefits.map((b) => b.toEntity()).toList(),
    trialDays: trialDays,
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
class BenefitDto with _$BenefitDto {
  const factory BenefitDto({
    required String title,
    required String description,
  }) = _BenefitDto;

  factory BenefitDto.fromJson(Map<String, dynamic> json) =>
      _$BenefitDtoFromJson(json);

  const BenefitDto._();

  BenefitEntity toEntity() => BenefitEntity(
    title: title,
    description: description,
  );
}
