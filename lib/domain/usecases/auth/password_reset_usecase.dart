import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class PasswordResetUseCase implements UseCase<ApiResponse, PasswordResetParams> {
  final AuthRepository _authRepository;

  PasswordResetUseCase(this._authRepository);

  @override
  Future<Either<Failure, ApiResponse>> call(PasswordResetParams params) async {
    return await _authRepository.passwordReset(
      email: params.email,
      code: params.code,
      newPassword: params.newPassword,
      newPasswordConfirmation: params.newPasswordConfirmation,
    );
  }
}

class PasswordResetParams {
  final String email;
  final int code;
  final String newPassword;
  final String newPasswordConfirmation;

  const PasswordResetParams({
    required this.email,
    required this.code,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });
}
