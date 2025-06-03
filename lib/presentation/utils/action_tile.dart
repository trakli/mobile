import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/utils/colors.dart';

class ActionTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String? subTitle;
  final String iconPath;
  final Color actionColor;

  const ActionTile({
    super.key,
    this.onTap,
    required this.title,
    this.subTitle,
    required this.iconPath,
    required this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            width: 0.5,
            color: transactionTileBorderColor,
          ),
        ),
        child: Row(
          spacing: 16.w,
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: actionColor.withValues(alpha: 0.2),
              ),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  actionColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subTitle != null)
                  Text(
                    subTitle ?? "",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      color: neutral300,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(
              Assets.images.arrowRight,
              // colorFilter: ColorFilter.mode(
              //   actionColor,
              //   BlendMode.srcIn,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
