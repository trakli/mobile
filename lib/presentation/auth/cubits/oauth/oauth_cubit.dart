import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/services/oauth_service.dart';
import 'package:trakli/data/datasources/auth/auth_remote_data_source.dart';
import 'package:trakli/domain/entities/user_entity.dart';

part 'oauth_cubit.freezed.dart';
part 'oauth_state.dart';

@injectable
class OAuthCubit extends Cubit<OAuthState> {
  final OAuthService _oauthService;

  OAuthCubit(this._oauthService) : super(const OAuthState.initial());

  /// Unified method for social authentication
  Future<void> signInWithSocial(SocialAuthType type) async {
    if (state is _Submitting) return;
    emit(const OAuthState.submitting());

    final result = await _oauthService.signInWithSocial(type);

    result.fold(
      (failure) => emit(OAuthState.error(failure)),
      (user) => emit(OAuthState.success(user)),
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    await signInWithSocial(SocialAuthType.google);
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    await signInWithSocial(SocialAuthType.apple);
  }
}
