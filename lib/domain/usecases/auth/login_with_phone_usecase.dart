import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class LoginWithPhoneUseCase implements UseCase<void, LoginWithPhoneParams> {
  final AuthRepository _authRepository;

  LoginWithPhoneUseCase(this._authRepository);

  @override
  Future<Either<Failure, void>> call(LoginWithPhoneParams params) async {
    return await _authRepository.loginWithPhonePassword(
      phone: params.phone,
      password: params.password,
    );
  }
}

class LoginWithPhoneParams {
  final String phone;
  final String password;

  const LoginWithPhoneParams({
    required this.phone,
    required this.password,
  });
}
