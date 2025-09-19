import 'package:easy_localization/easy_localization.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

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

  VerifyEmailParams({
    this.email,
    this.phone,
    required this.type,
    required this.code,
  }) : assert(
          email != null || phone != null,
          LocaleKeys.emailPhoneValidateDesc.tr(),
        );
}
