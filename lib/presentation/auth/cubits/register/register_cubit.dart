import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/usecases/auth/register_usecase.dart';

part 'register_state.dart';
part 'register_cubit.freezed.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(
    this._registerUseCase,
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
}
