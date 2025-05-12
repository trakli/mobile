import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import '../../entities/onboarding_entity.dart';
import '../../repositories/onboarding_repository.dart';

@injectable
class GetOnboardingState extends UseCase<OnboardingEntity?, NoParams> {
  final OnboardingRepository repository;

  GetOnboardingState(this.repository);

  @override
  Future<Either<Failure, OnboardingEntity?>> call(NoParams params) async {
    return repository.getOnboardingState();
  }
}
