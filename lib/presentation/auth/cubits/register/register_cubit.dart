import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/usecases/auth/create_user_new_usecase.dart';
import 'package:trakli/domain/usecases/auth/get_otp_usecase.dart';
import 'package:trakli/domain/usecases/auth/register_usecase.dart';
import 'package:trakli/domain/usecases/auth/verify_email_usecase.dart';

part 'register_cubit.freezed.dart';
part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;
  final GetOtpCodeUseCase _getOtpCodeUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final CreateUserNewUseCase _createUserNewUseCase;

  RegisterCubit(
    this._registerUseCase,
    this._getOtpCodeUseCase,
    this._verifyEmailUseCase,
    this._createUserNewUseCase,
  ) : super(const RegisterState.initial());

  Future<void> register({
    required String firstName,
    String? lastName,
    required String username,
    required String phone,
    required String password,
    required String email,
  }) async {
    emit(const RegisterState.submitting());
    // showLoader();

    final result = await _registerUseCase(
      RegisterParams(
        firstName: firstName,
        lastName: lastName,
        username: username,
        phone: phone,
        password: password,
        email: email,
      ),
    );

    result.fold(
      (failure) {
        // hideLoader();
        emit(RegisterState.error(failure));
      },
      (user) {
        // hideLoader();
        emit(RegisterState.success(user));
      },
    );
  }

  Future<void> getOtpCode({required String email}) async {
    emit(const RegisterState.submitting());

    final result = await _getOtpCodeUseCase(
      GetOtpCodeParams(
        email: email,
      ),
    );

    result.fold(
      (failure) {
        emit(RegisterState.error(failure));
      },
      (response) {
        emit(RegisterState.process(response));
      },
    );
  }
}
