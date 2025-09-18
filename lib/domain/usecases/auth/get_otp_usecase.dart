import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';

@injectable
class GetOtpCodeUseCase implements UseCase<ApiResponse, GetOtpCodeParams> {
  final AuthRepository _authRepository;

  GetOtpCodeUseCase(this._authRepository);

  @override
  Future<Either<Failure, ApiResponse>> call(
    GetOtpCodeParams params,
  ) async {
    return await _authRepository.getOtpCode(
      email: params.email,
      phone: params.phone,
      type: params.type,
    );
  }
}

class GetOtpCodeParams {
  final String? email;
  final String? phone;
  final String type;

  const GetOtpCodeParams({
    this.email,
    this.phone,
    required this.type,
  });
}
