import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class LoginByPhoneUsecase extends UseCase<void, UserLoginByPhoneParams> {
  LoginByPhoneUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(UserLoginByPhoneParams params) {
    return _repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginByPhoneParams {
  final String email;
  final String password;

  UserLoginByPhoneParams({
    required this.email,
    required this.password,
  });
}
