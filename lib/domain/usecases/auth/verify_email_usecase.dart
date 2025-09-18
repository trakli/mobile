import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class VerifyEmailUseCase implements UseCase<ApiResponse, VerifyEmailParams> {
  final AuthRepository _authRepository;

  VerifyEmailUseCase(this._authRepository);

  @override
  Future<Either<Failure, ApiResponse>> call(
    VerifyEmailParams params,
  ) async {
    return await _authRepository.verifyEmail(
      email: params.email,
      phone: params.phone,
      code: params.code,
      type: params.type,
    );
  }
}

class VerifyEmailParams {
  final String? email;
  final String? phone;
  final String type;
  final String code;

  const VerifyEmailParams({
    this.email,
    this.phone,
    required this.type,
    required this.code,
  });
}
