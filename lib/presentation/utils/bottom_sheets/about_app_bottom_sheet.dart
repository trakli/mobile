import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class AboutAppBottomSheet extends StatelessWidget {
  const AboutAppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.images.logoGreen,
            height: 60.h,
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.aboutAppDescription.tr(),
            style: TextStyle(
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    openUrl(url: "https://trakli.app/privacy");
                  },
                  child: Text(
                    LocaleKeys.privacyPolicy.tr(),
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(
                Icons.circle,
                size: 6.r,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    openUrl(url: "https://trakli.app/terms");
                  },
                  child: Text(
                    LocaleKeys.termsAndConditions.tr(),
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
