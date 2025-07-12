import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/subscription_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class PremiumDialog extends StatefulWidget {
  const PremiumDialog({super.key});

  @override
  State<PremiumDialog> createState() => _PremiumDialogState();
}

class _PremiumDialogState extends State<PremiumDialog> {
  PlanType type = PlanType.monthly;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 48.h,
          horizontal: 16.w,
        ),
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.upgradeToPremium.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                color: neutralN700,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              loremIpsum,
              style: TextStyle(
                fontSize: 14.sp,
                color: neutralN900,
              ),
              textAlign: TextAlign.center,
            ),
            SubscriptionTile(
              planType: PlanType.monthly,
              isSelected: type == PlanType.monthly,
              onTap: () {
                setState(() {
                  type = PlanType.monthly;
                });
              },
            ),
            SubscriptionTile(
              planType: PlanType.yearly,
              isSelected: type == PlanType.yearly,
              onTap: () {
                setState(() {
                  type = PlanType.yearly;
                });
              },
            ),
            Row(
              spacing: 16.w,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        AppNavigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neutralN40,
                        foregroundColor: neutralN900,
                      ),
                      child: Text(LocaleKeys.cancel.tr()),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPrimaryColor,
                      ),
                      onPressed: () {},
                      child: Text(LocaleKeys.confirm.tr()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
