import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/usecases/auth/login_with_email_password.dart';
import 'package:trakli/domain/usecases/auth/login_with_phone_password.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginWithEmailPassword _loginWithEmailPassword;
  final LoginWithPhonePassword _loginWithPhonePassword;

  LoginCubit(
    this._loginWithEmailPassword,
    this._loginWithPhonePassword,
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
    emit(const LoginState.submitting());

    // final result = await _loginWithPhonePassword(
    //   LoginWithPhoneParams(
    //     phone: phone,
    //     password: password,
    //   ),
    // );
    //
    // result.fold(
    //       (failure) => emit(LoginState.error(failure)),
    //       (user) => emit(LoginState.success(user)),
    // );
  }
}
