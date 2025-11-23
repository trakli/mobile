part of 'oauth_cubit.dart';

@freezed
class OAuthState with _$OAuthState {
  const factory OAuthState.initial() = _Initial;
  const factory OAuthState.submitting() = _Submitting;
  const factory OAuthState.success(UserEntity user) = _Success;
  const factory OAuthState.error(Failure failure) = _Error;
}
