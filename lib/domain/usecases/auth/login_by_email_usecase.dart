import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class LoginByEmailUsecase extends UseCase<void, UserLoginByEmailParams> {
  LoginByEmailUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(UserLoginByEmailParams params) {
    return _repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginByEmailParams {
  final String email;
  final String password;

  UserLoginByEmailParams({
    required this.email,
    required this.password,
  });
}
