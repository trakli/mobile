// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_benefit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CloudBenefitDtoImpl _$$CloudBenefitDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CloudBenefitDtoImpl(
      overview: OverviewDto.fromJson(json['overview'] as Map<String, dynamic>),
      benefits: (json['benefits'] as List<dynamic>)
          .map((e) => BenefitDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      trialDays: (json['trial_days'] as num).toInt(),
    );

Map<String, dynamic> _$$CloudBenefitDtoImplToJson(
        _$CloudBenefitDtoImpl instance) =>
    <String, dynamic>{
      'overview': instance.overview.toJson(),
      'benefits': instance.benefits.map((e) => e.toJson()).toList(),
      'trial_days': instance.trialDays,
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

_$BenefitDtoImpl _$$BenefitDtoImplFromJson(Map<String, dynamic> json) =>
    _$BenefitDtoImpl(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$BenefitDtoImplToJson(_$BenefitDtoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };
