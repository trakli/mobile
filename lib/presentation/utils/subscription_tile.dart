import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/subscription_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class SubscriptionTile extends StatefulWidget {
  final bool isSelected;
  final PlanEntity plan;
  final VoidCallback? onTap;

  const SubscriptionTile({
    super.key,
    this.isSelected = false,
    required this.plan,
    this.onTap,
  });

  @override
  State<SubscriptionTile> createState() => _SubscriptionTileState();
}

class _SubscriptionTileState extends State<SubscriptionTile> {
  PlanType planType = PlanType.monthly;

  @override
  void initState() {
    planType = getPlanType(widget.plan.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(8.r),
          border: widget.isSelected
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
                    widget.plan.name,
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
                      LocaleKeys.recommended.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const Spacer(),
                Icon(
                  widget.isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: widget.isSelected ? appPrimaryColor : Colors.grey,
                ),
              ],
            ),
            Text(
              "${widget.plan.priceFormatted}/${widget.plan.interval}",
              style: TextStyle(
                fontSize: 18.sp,
                color: neutralM900,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              widget.plan.cta.text,
              style: TextStyle(
                fontSize: 14.sp,
                color: neutralM700,
                fontWeight: FontWeight.w700,
              ),
            ),
            Divider(height: 0, thickness: 1.5.h),
            ...widget.plan.features.map<Widget>((feature) {
              return Row(
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
                      feature,
                      style: TextStyle(
                        color: neutralM700,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
