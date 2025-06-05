import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';

class PopUpDialog extends StatelessWidget {
  final DialogType dialogType;
  final Color? accentColor;
  final VoidCallback? mainAction;
  final VoidCallback? secondaryAction;
  final String? iconPath;
  final String title;
  final String subTitle;
  final String? mainActionText;
  final String? secondaryActionText;

  const PopUpDialog({
    super.key,
    required this.title,
    required this.subTitle,
    this.dialogType = DialogType.positive,
    this.accentColor,
    this.mainAction,
    this.secondaryAction,
    this.iconPath,
    this.mainActionText,
    this.secondaryActionText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        vertical: 20.h,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              height: 86.h,
              iconPath ??
                  (dialogType == DialogType.positive
                      ? Assets.images.checkCircle
                      : Assets.images.warning),
              colorFilter: ColorFilter.mode(
                accentColor ??
                    (dialogType == DialogType.positive
                        ? appPrimaryColor
                        : appDangerColor),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                color: accentColor ??
                    (dialogType == DialogType.positive
                        ? appPrimaryColor
                        : appDangerColor),
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              subTitle,
              style: TextStyle(
                color: neutralN900,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Row(
              spacing: 16.w,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: secondaryAction ??
                          () {
                            AppNavigator.pop(context);
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neutralN40,
                        foregroundColor: neutralN900,
                      ),
                      child: Text(secondaryActionText ?? "Cancel"),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor ??
                            (dialogType == DialogType.positive
                                ? appPrimaryColor
                                : appDangerColor),
                      ),
                      onPressed: mainAction ?? () {},
                      child: Text(mainActionText ?? "Confirm"),
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
