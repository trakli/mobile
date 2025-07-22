import 'package:trakli/data/datasources/subscription/dto/subscription_dto.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';

class SubscriptionMapper {
  static SubscriptionEntity toDomain(SubscriptionDto dto) {
    return SubscriptionEntity(
      region: dto.region,
      currency: dto.currency,
      trialDays: dto.trialDays,
      freePlanEnabled: dto.freePlanEnabled,
      plans: dto.plans.map((planDto) => _mapPlanDtoToEntity(planDto)).toList(),
    );
  }

  static PlanEntity _mapPlanDtoToEntity(PlanDto planDto) {
    return PlanEntity(
      id: planDto.id,
      name: planDto.name,
      interval: planDto.interval,
      features: planDto.features,
      cta: _mapCtaDtoToEntity(planDto.cta),
      priceCents: planDto.priceCents,
      currency: planDto.currency,
      trialDays: planDto.trialDays,
    );
  }

  static CtaEntity _mapCtaDtoToEntity(CtaDto ctaDto) {
    return CtaEntity(
      text: ctaDto.text,
      buttonText: ctaDto.buttonText,
    );
  }
}
