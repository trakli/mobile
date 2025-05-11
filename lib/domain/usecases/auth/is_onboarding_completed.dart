import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class IsOnboardingCompleted implements UseCase<bool, NoParams> {
  final AuthRepository _repository;

  IsOnboardingCompleted(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.isOnboardingCompleted();
  }
}
