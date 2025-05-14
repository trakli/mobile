import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class LoginWithPhonePassword
    implements UseCase<UserEntity, LoginWithPhoneParams> {
  final AuthRepository _repository;

  LoginWithPhonePassword(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithPhoneParams params) async {
    return await _repository.loginWithPhonePassword(
      phone: params.phone,
      password: params.password,
    );
  }
}

class LoginWithPhoneParams {
  final String phone;
  final String password;

  LoginWithPhoneParams({
    required this.phone,
    required this.password,
  });
}
