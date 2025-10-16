import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/services/oauth_service.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/pages/login_with_email_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/onboarding/onboard_settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final OAuthService _oauthService = getIt<OAuthService>();
  bool _isLoading = false;

  /// Handle Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _oauthService.signInWithGoogle();

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Google Sign-In failed: ${failure.customMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (user) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Google Sign-In successful!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to main app or handle success
            // Navigator.pushReplacementNamed(context, '/main');
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handle Apple Sign-In
  Future<void> _handleAppleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _oauthService.signInWithApple();

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Apple Sign-In failed: ${failure.customMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (user) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Apple Sign-In successful!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to main app or handle success
            // Navigator.pushReplacementNamed(context, '/main');
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 24.h,
        ),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Text(
              LocaleKeys.welcomeTo.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            SvgPicture.asset(
              Assets.images.logoGreen,
            ),
            SvgPicture.asset(
              Assets.images.loginLogo,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: PrimaryButton(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithEmailScreen(),
                    ),
                  );
                },
                buttonText: LocaleKeys.login.tr(),
                buttonTextColor: Colors.black,
                backgroundColor: const Color(0xFFDFE1E4),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: PrimaryButton(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                buttonText: LocaleKeys.createAccount.tr(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.sp),
              child: Row(
                spacing: 28.w,
                children: [
                  const Expanded(
                    child: Divider(
                      height: 0,
                      color: Color(0xFF79828E),
                    ),
                  ),
                  Text(LocaleKeys.or.tr()),
                  const Expanded(
                    child: Divider(
                      height: 0,
                      color: Color(0xFF79828E),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 54.h,
              child: PrimaryButton(
                onPress: _isLoading ? null : _handleGoogleSignIn,
                iconPath: Assets.images.google,
                borderColor: const Color(0xFF79828E),
                backgroundColor: Colors.white,
                buttonText: _isLoading
                    ? 'Signing in...'
                    : LocaleKeys.proceedWithGoogle.tr(),
                buttonTextColor: textColor,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 54.h,
              child: PrimaryButton(
                onPress: _isLoading ? null : _handleAppleSignIn,
                iconPath: Assets.images.apple,
                borderColor: const Color(0xFF79828E),
                backgroundColor: Colors.white,
                buttonText: _isLoading
                    ? 'Signing in...'
                    : LocaleKeys.proceedWithApple.tr(),
                buttonTextColor: textColor,
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () {
                AppNavigator.push(
                  context,
                  const OnboardSettingsScreen(),
                );
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              child: Text(
                LocaleKeys.skip.tr(),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
