import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class LoginWithEmailUseCase implements UseCase<void, LoginWithEmailParams> {
  final AuthRepository _authRepository;

  LoginWithEmailUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(LoginWithEmailParams params) async {
    return await _authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailParams {
  final String email;
  final String password;

  const LoginWithEmailParams({
    required this.email,
    required this.password,
  });
}
