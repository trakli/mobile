import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/core/utils/currency_formater.dart' show CurrencyFormater;
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';

class SubscriptionTile extends StatelessWidget {
  final bool isSelected;
  final PlanType planType;
  final VoidCallback? onTap;

  const SubscriptionTile({
    super.key,
    this.isSelected = false,
    required this.planType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(8.r),
          border: isSelected
              ? Border.all(
                  width: 2.w,
                  color: appPrimaryColor,
                )
              : null,
        ),
        child: Column(
          spacing: 4.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8.w,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: planType == PlanType.monthly ? appGrey : appYellow,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    planType == PlanType.monthly ? "Monthly" : "Yearly",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: neutralM900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (planType == PlanType.yearly)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: appOrange,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Recommended",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const Spacer(),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? appPrimaryColor : Colors.grey,
                ),
              ],
            ),
            Text(
              "${CurrencyFormater.formatAmountWithSymbol(
                context,
                planType == PlanType.monthly ? 4000 : 10000,
                currentDecimalDigits: 0,
                compact: true,
              )}/Month",
              style: TextStyle(
                fontSize: 18.sp,
                color: neutralM900,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Lorem ipsum dolor sit amet consectetur.",
              style: TextStyle(
                fontSize: 14.sp,
                color: neutralM700,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(height: 0, thickness: 1.5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.w,
              children: [
                SvgPicture.asset(
                  width: 16.w,
                  height: 16.h,
                  Assets.images.arrowCircleRight,
                  colorFilter: ColorFilter.mode(
                    appPrimaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                Expanded(
                  child: Text(
                    loremIpsum,
                    style: TextStyle(
                      color: neutralM700,
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
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
