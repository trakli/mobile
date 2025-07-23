import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/error/failures/failures.dart' show Failure;
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/pages/login_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/benefits/cubit/benefits_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/benefit_tile.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart' show showSnackBar;

class BenefitsWidget extends StatelessWidget {
  const BenefitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BenefitsCubit, BenefitsState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          showSnackBar(
            message: state.failure.customMessage,
            borderRadius: 8.r,
          );
        }
      },
      builder: (context, state) {
        final benefits = state.cloudBenefits?.benefits ?? [];

        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(appPrimaryColor),
            ),
          );
        }
        return Column(
          spacing: 24.h,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: neutralN500,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  Text(
                    LocaleKeys.dontHaveAccount.tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: appOrange,
                    ),
                  ),
                  Text(
                    state.cloudBenefits?.overview.description ?? "",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: neutralN700,
                    ),
                  ),
                  Text(
                    state.cloudBenefits?.overview.title ?? "",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: neutralN700,
                    ),
                  ),
                  if (benefits.isNotEmpty)
                    ...benefits.map<Widget>((benefit) {
                      return BenefitTile(
                        benefit: benefit,
                      );
                    }),
                ],
              ),
            ),
            SizedBox(
              height: 52.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AppNavigator.removeAllPreviousAndPushThenPush(
                    context,
                    const LoginScreen(),
                    const RegisterScreen(),
                  );
                },
                child: Text(
                  LocaleKeys.createAccountNow.tr(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
