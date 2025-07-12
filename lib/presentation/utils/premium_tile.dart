import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/dialogs/premium_dialog.dart';
import 'package:trakli/presentation/utils/helpers.dart' show showCustomDialog;
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class PremiumTile extends StatelessWidget {
  const PremiumTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCustomDialog(
          widget: const PremiumDialog(),
        );
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
}
