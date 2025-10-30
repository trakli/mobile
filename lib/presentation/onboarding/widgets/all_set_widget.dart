import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';

class AllSetWidget extends StatelessWidget {
  final VoidCallback onTap;

  const AllSetWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.h),
          CircleAvatar(
            radius: 30.sp,
            backgroundColor: appPrimaryColor,
            child: Icon(
              Icons.check_circle_outline,
              size: 28.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            LocaleKeys.youAllSetTitleOne.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            LocaleKeys.allSetDesc.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 16.h),
          const Expanded(
            child: Column(
              children: [],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 52.h,
            width: double.infinity,
            child: PrimaryButton(
              onPress: onTap,
              buttonText: LocaleKeys.goToDashboard.tr(),
            ),
          )
        ],
      ),
    );
  }
}
