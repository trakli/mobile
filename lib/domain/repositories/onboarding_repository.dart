import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';

import '../entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, Unit>> saveOnboardingState(OnboardingEntity entity);
  Future<Either<Failure, OnboardingEntity?>> getOnboardingState();
  Future<Either<Failure, Unit>> resetOnboarding();
  // Future<Either<Failure, Unit>> setOnboarding();
  Stream<OnboardingEntity?> get onboardingState;
}
