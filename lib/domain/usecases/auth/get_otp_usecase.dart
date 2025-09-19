import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

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

  GetOtpCodeParams({
    this.email,
    this.phone,
    required this.type,
  }) : assert(
          email != null || phone != null,
          LocaleKeys.emailPhoneValidateDesc.tr(),
        );
}
