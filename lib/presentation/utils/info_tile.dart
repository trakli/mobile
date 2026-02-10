import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/colors.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? countryCode;

  const InfoTile({
    super.key,
    required this.title,
    required this.subTitle,
    this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 0.5,
          color: transactionTileBorderColor,
        ),
      ),
      child: Column(
        spacing: 8.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          Row(
            spacing: 4.w,
            children: [
              if (countryCode != null) ...[
                CountryFlag.fromCountryCode(
                  shape: const Circle(),
                  countryCode ?? "cm",
                  width: 24.w,
                ),
              ],
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
