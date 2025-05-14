import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import '../../entities/onboarding_entity.dart';
import '../../repositories/onboarding_repository.dart';

@injectable
class SaveOnboardingState extends UseCase<Unit, SaveOnboardingStateParams> {
  final OnboardingRepository repository;

  SaveOnboardingState(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveOnboardingStateParams params) {
    return repository.saveOnboardingState(params.entity);
  }
}

class SaveOnboardingStateParams {
  final OnboardingEntity entity;

  SaveOnboardingStateParams({
    required this.entity,
  });
}
