import 'package:injectable/injectable.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/onboarding_entity.dart';
import 'package:trakli/domain/repositories/onboarding_repository.dart';

@injectable
class GetOnboardingStateStream
    implements NoEitherStreamUseCase<OnboardingEntity?, NoParams> {
  final OnboardingRepository repository;

  GetOnboardingStateStream(this.repository);

  @override
  Stream<OnboardingEntity?> call(NoParams params) {
    return repository.onboardingState;
  }
}
