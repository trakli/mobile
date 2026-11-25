import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trakli/presentation/auth/cubits/login/login_cubit.dart';
import 'package:trakli/presentation/auth/cubits/oauth/oauth_cubit.dart';
import 'package:trakli/presentation/auth/cubits/register/register_cubit.dart';
import 'package:trakli/presentation/auth/pages/forgot_password_screen.dart';
import 'package:trakli/presentation/auth/pages/login_screen.dart';
import 'package:trakli/presentation/auth/pages/login_with_email_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/config/theme_cubit/theme_cubit.dart';
import 'package:trakli/presentation/onboarding/onboarding_screen.dart';
import 'package:trakli/presentation/onboarding/widgets/all_set_widget.dart';
import 'package:trakli/presentation/onboarding/widgets/group_setup_widget.dart';
import 'package:flutter/material.dart';

import 'ledger_fixtures.dart';
import 'ledger_harness.dart';

class _MockLogin extends Mock implements LoginCubit {}

class _MockRegister extends Mock implements RegisterCubit {}

class _MockOAuth extends Mock implements OAuthCubit {}

class _MockTheme extends Mock implements ThemeCubit {}

T _stub<T extends StateStreamableSource<S>, S>(T cubit, S state) {
  when(() => cubit.state).thenReturn(state);
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => cubit.isClosed).thenReturn(false);
  when(() => cubit.close()).thenAnswer((_) async {});
  return cubit;
}

List<BlocProvider> _extra() => [
      BlocProvider<LoginCubit>.value(
        value: _stub(_MockLogin(), const LoginState.initial()),
      ),
      BlocProvider<RegisterCubit>.value(
        value: _stub(_MockRegister(), const RegisterState.initial()),
      ),
      BlocProvider<OAuthCubit>.value(
        value: _stub(_MockOAuth(), const OAuthState.initial()),
      ),
      BlocProvider<ThemeCubit>.value(
        value: _stub(_MockTheme(), ThemeMode.light),
      ),
    ];

void main() {
  setUpAll(() async {
    await loadLedgerFonts();
    loadEnglishTranslations();
  });

  testWidgets('login', (tester) async {
    await captureLedgerShots(tester, 'login',
        (dark) => withShotProviders(const LoginScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  testWidgets('login email', (tester) async {
    await captureLedgerShots(
        tester,
        'login-email',
        (dark) =>
            withShotProviders(const LoginWithEmailScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  testWidgets('register', (tester) async {
    await captureLedgerShots(tester, 'register',
        (dark) => withShotProviders(const RegisterScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  testWidgets('forgot password', (tester) async {
    await captureLedgerShots(
        tester,
        'forgot',
        (dark) =>
            withShotProviders(const ForgotPasswordScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  testWidgets('onboarding', (tester) async {
    await captureLedgerShots(tester, 'onboarding',
        (dark) => withShotProviders(const OnboardingScreen(), extra: _extra()));
  }, skip: !ledgerShotsEnabled);

  for (final step in <String, Widget Function()>{
    'step-group': () => GroupSetupWidget(onNext: () {}, onPrev: () {}),
    'step-done': () => AllSetWidget(onTap: () {}, onPrev: () {}),
  }.entries) {
    testWidgets(step.key, (tester) async {
      await captureLedgerShots(
        tester,
        step.key,
        (dark) => withShotProviders(
          Scaffold(body: SafeArea(child: step.value())),
          extra: _extra(),
        ),
      );
    }, skip: !ledgerShotsEnabled);
  }
}
