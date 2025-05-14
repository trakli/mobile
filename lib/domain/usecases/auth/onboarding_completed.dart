import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class OnboardingCompleted implements UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  OnboardingCompleted(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.onboardingCompleted();
  }
}
