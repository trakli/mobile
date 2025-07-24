part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(Failure failure) = _Error;

  const AuthState._();

  UserEntity? get user =>
      this is _Authenticated ? (this as _Authenticated).user : null;

  bool get isAuthenticated => this is _Authenticated;
}
