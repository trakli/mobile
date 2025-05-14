part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.submitting() = _Submitting;
  const factory LoginState.success(UserEntity user) = _Success;
  const factory LoginState.error(Failure failure) = _Error;
}
