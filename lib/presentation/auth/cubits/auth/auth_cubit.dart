import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/usecases/auth/get_loggedin_user.dart';
import 'package:trakli/domain/usecases/auth/logout_usecase.dart';
import 'package:trakli/domain/usecases/auth/stream_auth_status.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final StreamAuthStatus _streamAuthStatus;
  final GetLoggedInUser _getLoggedInUser;
  StreamSubscription<AuthStatus>? _authSubscription;
  final LogoutUsecase _logoutUsecase;

  AuthCubit(
    this._streamAuthStatus,
    this._getLoggedInUser,
    this._logoutUsecase,
  ) : super(const AuthState.initial()) {
    // listenToAuthStatus();
  }

  void listenToAuthStatus() {
    _authSubscription?.cancel();

    print('AuthCubit: Starting to listen to auth status');
    _authSubscription =
        _streamAuthStatus(NoParams()).listen((authStatus) async {
      print('AuthCubit: Received auth status: $authStatus');

      switch (authStatus) {
        case AuthStatus.authenticated:
          final result = await _getLoggedInUser(NoParams());
          result.fold(
            (failure) => emit(AuthState.error(failure)),
            (user) => emit(AuthState.authenticated(user)),
          );
          break;

        case AuthStatus.unauthenticated:
          emit(const AuthState.unauthenticated());
          break;

        case AuthStatus.unknown:
          emit(const AuthState.unauthenticated());
          break;
      }
    });

    emit(const AuthState.unauthenticated());
  }

  Future<void> logout() async {
    // emit(const AuthState.unauthenticated());
    final result = await _logoutUsecase(NoParams());

    result.fold((failure) => emit(AuthState.error(failure)), (unit) => null);
    //emit(const AuthState.unauthenticated()),
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
