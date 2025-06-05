import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/account_info_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/onboarding/onboarding_screen.dart';
import 'package:trakli/presentation/utils/action_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/premium_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    return Scaffold(
      appBar: CustomAppBar(
        titleText: LocaleKeys.profile.tr(),
        actions: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
            padding: EdgeInsets.all(8.r),
            child: Center(
              child: Icon(
                Icons.edit,
                size: 24.r,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            CircleAvatar(
              radius: 60.r,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Icon(
                      Icons.person,
                      size: 56.r,
                    ),
                  ),
                  Positioned(
                    right: 0.w,
                    bottom: 2.h,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(
                              alpha: 0.2,
                            ),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        Assets.images.edit2,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              user?.fullName ?? 'John Doe',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.w,
              children: [
                CountryFlag.fromCountryCode(
                  shape: const Circle(),
                  "cm",
                  width: 24.w,
                ),
                Text(
                  user?.email ?? 'you@example.com',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.h,
              children: [
                const PremiumTile(),
                ActionTile(
                  title: "Account Info",
                  iconPath: Assets.images.user,
                  actionColor: appPrimaryColor,
                  onTap: () {
                    AppNavigator.push(context, const AccountInfoScreen());
                  },
                ),
                ActionTile(
                  title: LocaleKeys.phoneNumber.tr(),
                  subTitle: user?.phone ?? "Not set",
                  iconPath: Assets.images.call,
                  actionColor: appPrimaryColor,
                ),
                ActionTile(
                  title: "Log Out",
                  iconPath: Assets.images.logout,
                  actionColor: Colors.red,
                  onTap: () {
                    showCustomDialog(
                      widget: PopUpDialog(
                        title: 'Log Out',
                        subTitle: 'Are you sure you want to logout?',
                        dialogType: DialogType.negative,
                        mainAction: () {
                          if (user != null) {
                            context.read<AuthCubit>().logout();
                          } else {
                            AppNavigator.removeAllPreviousAndPush(
                              context,
                              const OnboardingScreen(),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
