import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/plans/cubit/plans_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/dialogs/premium_dialog.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showCustomDialog, showSnackBar;

class PremiumTile extends StatelessWidget {
  const PremiumTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlansCubit, PlansState>(
      listener: (context, state) {
        // Show error message for any failure except notFound
        if (state.failure != const Failure.none() &&
            !state.failure.maybeWhen(
              notFound: () => true,
              orElse: () => false,
            )) {
          showSnackBar(
            message: state.failure.customMessage,
            borderRadius: 8.r,
          );
        }
      },
      builder: (context, state) {
        // Hide completely if failure is notFound
        if (state.failure.maybeWhen(
          notFound: () => true,
          orElse: () => false,
        )) {
          return const SizedBox.shrink();
        }

        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(appPrimaryColor),
            ),
          );
        }

        if (state.subscription != null) {
          return InkWell(
            onTap: () {
              final subscriptionInfo = state.subscription;
              if (subscriptionInfo != null) {
                showCustomDialog(
                  widget: PremiumDialog(
                    subscription: subscriptionInfo,
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.all(2.sp), // Border thickness
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD17E),
                    Color(0xFFFF9441),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDCC), // Inner background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  spacing: 8.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.images.premiumPng.path),
                    Text(
                      LocaleKeys.upgradeToPremium.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
