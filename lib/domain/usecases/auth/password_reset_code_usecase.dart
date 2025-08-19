import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class PasswordResetCodeUseCase implements UseCase<void, PasswordResetCodeParams> {
  final AuthRepository _authRepository;

  PasswordResetCodeUseCase(this._authRepository);

  @override
  Future<Either<Failure, ApiResponse>> call(PasswordResetCodeParams params) async {
    return await _authRepository.passwordResetCode(
      email: params.email,
    );
  }
}

class PasswordResetCodeParams {
  final String email;

  const PasswordResetCodeParams({
    required this.email,
  });
}
