import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class LoginWithEmailPassword
    implements UseCase<UserEntity, LoginWithEmailParams> {
  final AuthRepository _repository;

  LoginWithEmailPassword(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithEmailParams params) async {
    return await _repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailParams {
  final String email;
  final String password;

  LoginWithEmailParams({
    required this.email,
    required this.password,
  });
}
