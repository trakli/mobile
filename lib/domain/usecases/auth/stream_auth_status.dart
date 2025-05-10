import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class StreamAuthStatus implements StreamUseCase<AuthStatus, NoParams> {
  final AuthRepository _repository;

  StreamAuthStatus(this._repository);

  @override
  Stream<Either<Failure, AuthStatus>> call(NoParams params) {
    return _repository.authStatus.map((status) => Either.right(status));
  }
}
