import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/register/register_cubit.dart';
import 'package:trakli/presentation/auth/pages/login_with_email_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_text_field.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TapGestureRecognizer _recognizerTap;

  @override
  void initState() {
    _recognizerTap = TapGestureRecognizer()
      ..onTap = () {
        AppNavigator.pushReplacement(
          context,
          const LoginWithEmailScreen(),
        );
      };
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
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
                backgroundColor: expenseRedText);
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  LocaleKeys.createAccount.tr(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 28.h),
                Text(
                  LocaleKeys.firstName.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: firstNameController,
                  hintText: LocaleKeys.firstName.tr(),
                  filled: true,
                  validator: validateFirstName,
                ),
                SizedBox(height: 16.h),
                Text(
                  LocaleKeys.lastName.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: lastNameController,
                  hintText: LocaleKeys.lastName.tr(),
                  filled: true,
                ),
                SizedBox(height: 16.h),
                Text(
                  LocaleKeys.username.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: usernameController,
                  hintText: LocaleKeys.username.tr(),
                  filled: true,
                ),
                SizedBox(height: 16.h),
                Text(
                  LocaleKeys.email.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: emailController,
                  hintText: LocaleKeys.email.tr(),
                  filled: true,
                  validator: validateEmail,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.passEmptyDesc.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: Builder(builder: (context) {
                    return PrimaryButton(
                      onPress: () {
                        if (formKey.currentState!.validate()) {
                          context.read<RegisterCubit>().register(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                username: usernameController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                                email: emailController.text,
                              );
                        }
                      },
                      buttonText: LocaleKeys.createAccount.tr(),
                      buttonTextColor: Colors.white,
                    );
                  }),
                ),
                SizedBox(height: 16.h),
                Align(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have account? ",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: neutralN700,
                      ),
                      children: [
                        TextSpan(
                          text: LocaleKeys.login.tr(),
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
