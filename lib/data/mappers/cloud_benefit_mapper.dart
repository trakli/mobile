import 'package:trakli/data/datasources/benefits/dto/cloud_benefit_dto.dart';
import 'package:trakli/domain/entities/cloud_benefit_entity.dart';

class CloudBenefitMapper {
  static CloudBenefitEntity toDomain(CloudBenefitDto dto) {
    return CloudBenefitEntity(
      overview: _mapOverviewDtoToEntity(dto.overview),
      benefits: dto.benefits.map((b) => _mapBenefitDtoToEntity(b)).toList(),
      trialDays: dto.trialDays,
    );
  }

  static OverviewEntity _mapOverviewDtoToEntity(OverviewDto overviewDto) {
    return OverviewEntity(
      title: overviewDto.title,
      description: overviewDto.description,
    );
  }

  static BenefitEntity _mapBenefitDtoToEntity(BenefitDto benefitDto) {
    return BenefitEntity(
      title: benefitDto.title,
      description: benefitDto.description,
    );
  }
}
