import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/auth_status.dart';
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:trakli/domain/usecases/auth/get_loggedin_user.dart';
import 'package:trakli/domain/usecases/auth/stream_auth_status.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final StreamAuthStatus _streamAuthStatus;
  final GetLoggedInUser _getLoggedInUser;
  StreamSubscription? _authSubscription;

  AuthCubit(
    this._streamAuthStatus,
    this._getLoggedInUser,
  ) : super(const AuthState.initial()) {
    _listenToAuthStatus();
  }

  void _listenToAuthStatus() {
    _authSubscription?.cancel();
    _authSubscription = _streamAuthStatus(NoParams()).listen(
      (authStatus) async {
        authStatus.fold(
          (failure) => emit(AuthState.error(failure.message),),
          (status) async {
            switch (status) {
              case AuthStatus.authenticated:
                final result = await _getLoggedInUser(NoParams());
                result.fold(
                  (failure) => emit(AuthState.error(failure.message)),
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
      },
    );
  }

  void logout() {
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
