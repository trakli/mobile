import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/data/datasources/core/api_response.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/usecases/auth/login_with_email_password.dart';
import 'package:trakli/domain/usecases/auth/login_with_phone_password.dart';
import 'package:trakli/domain/usecases/auth/password_reset_code_usecase.dart';
import 'package:trakli/domain/usecases/auth/password_reset_usecase.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginWithEmailPassword _loginWithEmailPassword;
  final LoginWithPhonePassword _loginWithPhonePassword;
  final PasswordResetCodeUseCase _passwordResetCodeUseCase;
  final PasswordResetUseCase _passwordResetUseCase;

  LoginCubit(
    this._loginWithEmailPassword,
    this._loginWithPhonePassword,
    this._passwordResetCodeUseCase,
    this._passwordResetUseCase,
  ) : super(const LoginState.initial());

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (state is _Submitting) return;
    emit(const LoginState.submitting());

    final result = await _loginWithEmailPassword(
      LoginWithEmailParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => emit(LoginState.error(failure)),
      (user) => emit(LoginState.success(user)),
    );
  }

  Future<void> loginWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    emit(const LoginState.submitting());

    final result = await _loginWithPhonePassword(
      LoginWithPhoneParams(
        phone: phone,
        password: password,
      ),
    );

    result.fold(
      (failure) => emit(LoginState.error(failure)),
      (user) => emit(LoginState.success(user)),
    );
  }

  Future<void> passwordResetCode({
    required String email,
  }) async {
    if (state is _Submitting) return;
    emit(const LoginState.submitting());

    final result = await _passwordResetCodeUseCase(
      PasswordResetCodeParams(
        email: email,
      ),
    );

    result.fold(
      (failure) => emit(LoginState.error(failure)),
      (response) => emit(LoginState.resetCode(response)),
    );
  }

  Future<void> passwordReset({
    required String email,
    required String code,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (state is _Submitting) return;
    emit(const LoginState.submitting());

    final result = await _passwordResetUseCase(
      PasswordResetParams(
        email: email,
        code: code,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      ),
    );

    result.fold(
      (failure) => emit(LoginState.error(failure)),
      (response) => emit(LoginState.resetPassword(response)),
    );
  }
}
