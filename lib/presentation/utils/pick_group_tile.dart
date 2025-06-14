import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart' show Assets;
import 'package:trakli/presentation/utils/colors.dart';

class PickGroupTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;

  const PickGroupTile({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      decoration: BoxDecoration(
        color: neutralN20,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.images.profile2user,
            width: 16.w,
            height: 16.h,
            colorFilter: ColorFilter.mode(
              appOrange,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            "General",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Radio(
            activeColor: appPrimaryColor,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
