import 'package:trakli/data/models/onboarding_model.dart';
import 'package:trakli/domain/entities/onboarding_entity.dart';

class OnboardingMapper {
  static OnboardingEntity toEntity(OnboardingModel model) {
    return OnboardingEntity(
      selectedCurrency: model.selectedCurrency,
      defaultGroup: model.defaultGroup,
    );
  }

  static OnboardingModel toModel(OnboardingEntity entity) {
    return OnboardingModel(
      selectedCurrency: entity.selectedCurrency,
      defaultGroup: entity.defaultGroup,
    );
  }
}
