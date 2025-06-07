import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/helpers.dart';

import 'globals.dart' show loremIpsum;

class BenefitTile extends StatelessWidget {
  const BenefitTile({super.key});

  @override
  Widget build(BuildContext context) {
    return  ExpansionTile(
      tilePadding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      childrenPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white,
      iconColor: appOrange,
      collapsedIconColor: neutralN700,
      textColor: appOrange,
      collapsedTextColor: neutralN700,
      title: Text(
        'Benefits 1',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_outlined,
        size: 32.sp,
      ),
      children: [
        bulletPoint(loremIpsum),
        bulletPoint(loremIpsum),
        bulletPoint(loremIpsum),
        bulletPoint(loremIpsum),
      ],
    );
  }
}
