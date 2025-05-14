import 'package:injectable/injectable.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class StreamAuthStatus implements NoEitherStreamUseCase<AuthStatus, NoParams> {
  final AuthRepository _repository;

  StreamAuthStatus(this._repository);

  @override
  Stream<AuthStatus> call(NoParams params) {
    return _repository.authStatus;
  }
}
