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
import 'package:trakli/presentation/benefits/benefits_widget.dart';
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
                  if (user != null)
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
              user?.fullName ?? LocaleKeys.anonymous.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (user != null)
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
                    user.email,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 12.h),
            if (user != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12.h,
                children: [
                  const PremiumTile(),
                  ActionTile(
                    title: LocaleKeys.accountInfo.tr(),
                    iconPath: Assets.images.user,
                    actionColor: appPrimaryColor,
                    onTap: () {
                      AppNavigator.push(context, const AccountInfoScreen());
                    },
                  ),
                  ActionTile(
                    title: LocaleKeys.phoneNumber.tr(),
                    subTitle: user.phone ?? LocaleKeys.notSet.tr(),
                    iconPath: Assets.images.call,
                    actionColor: appPrimaryColor,
                  ),
                  ActionTile(
                    title: LocaleKeys.logOut.tr(),
                    iconPath: Assets.images.logout,
                    actionColor: Colors.red,
                    onTap: () {
                      showCustomDialog(
                        widget: PopUpDialog(
                          title: LocaleKeys.logOut.tr(),
                          subTitle: LocaleKeys.logoutConfirm.tr(),
                          dialogType: DialogType.negative,
                          mainAction: () {
                            context.read<AuthCubit>().logout();
                          },
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              const BenefitsWidget(),
            SizedBox(height: 62.h),
          ],
        ),
      ),
    );
  }
}
