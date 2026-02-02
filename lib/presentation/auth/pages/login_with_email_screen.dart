import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/login/login_cubit.dart';
import 'package:trakli/presentation/auth/pages/forgot_password_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_phone_field.dart';
import 'package:trakli/presentation/utils/custom_text_field.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class LoginWithEmailScreen extends StatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  State<LoginWithEmailScreen> createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TapGestureRecognizer _recognizerTap;
  late TabController _tabController;
  RegisterType loginType = RegisterType.email;
  String? _phoneNumber;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _recognizerTap = TapGestureRecognizer()
      ..onTap = () {
        AppNavigator.pushReplacement(
          context,
          const RegisterScreen(),
        );
      };
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _tabController.dispose();
    _recognizerTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.when(
            initial: () {},
            submitting: () {
              showLoader();
            },
            success: (user) {
              hideLoader();
            },
            error: (failure) {
              hideLoader();
              showSnackBar(
                message: failure.customMessage,
                borderRadius: 8.r,
              );
            },
            resetCode: (response) {},
            resetPassword: (response) {});
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.08.sh),
                Container(
                  width: 48.sp,
                  height: 32.sp,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(Assets.images.arrowLeft),
                  ),
                ),
                SizedBox(height: 12.sp),
                Text(
                  LocaleKeys.login.tr(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TabBar(
                  indicatorColor: appPrimaryColor,
                  labelColor: appPrimaryColor,
                  controller: _tabController,
                  onTap: (index) {
                    setState(() {
                      loginType = RegisterType.values.elementAt(index);
                    });
                  },
                  tabs: [
                    Tab(
                      text: LocaleKeys.email.tr(),
                    ),
                    Tab(
                      text: LocaleKeys.phoneNumber.tr(),
                    )
                  ],
                ),
                SizedBox(height: 28.h),
                Text(
                  loginType == RegisterType.email
                      ? LocaleKeys.email.tr()
                      : LocaleKeys.phoneNumber.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                if (loginType == RegisterType.email)
                  CustomTextField(
                    controller: emailController,
                    hintText: LocaleKeys.email.tr(),
                    filled: true,
                    validator: validateEmail,
                  )
                else
                  CustomPhoneField(
                    onChanged: (number) {
                      _phoneNumber = number.completeNumber;
                    },
                  ),
                SizedBox(height: 16.h),
                Text(
                  LocaleKeys.password.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: passwordController,
                  hintText: LocaleKeys.password.tr(),
                  isPassword: true,
                  filled: true,
                  validator: validatePassword,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: Builder(builder: (context) {
                    return PrimaryButton(
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          if (loginType == RegisterType.email) {
                            context.read<LoginCubit>().loginWithEmailPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          } else {
                            if (_phoneNumber != null &&
                                _phoneNumber!.isNotEmpty) {
                              context.read<LoginCubit>().loginWithPhonePassword(
                                    phone: _phoneNumber!,
                                    password: passwordController.text,
                                  );
                            }
                          }
                        }
                      },
                      buttonText: LocaleKeys.login.tr(),
                      buttonTextColor: Colors.white,
                    );
                  }),
                ),
                SizedBox(height: 4.h),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      AppNavigator.push(context, const ForgotPasswordScreen());
                    },
                    child: Text(
                      LocaleKeys.forgotPassword.tr(),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Align(
                  child: RichText(
                    text: TextSpan(
                      text: LocaleKeys.dontHaveAccount.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14.sp,
                          ),
                      children: [
                        const TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                          text: LocaleKeys.register.tr(),
                          style: TextStyle(
                            color: appPrimaryColor,
                          ),
                          recognizer: _recognizerTap,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
