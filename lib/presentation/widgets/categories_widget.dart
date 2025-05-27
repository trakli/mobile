import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/assets.gen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {super.key, required this.categories, required this.accentColor});

  final List<CategoryEntity> categories;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: categories
          .map((category) => Container(
                padding: EdgeInsets.symmetric(
                  vertical: 2.h,
                  horizontal: 6.w,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.w,
                  children: [
                    SvgPicture.asset(
                      width: 10.w,
                      height: 10.h,
                      Assets.images.wallet,
                      colorFilter: ColorFilter.mode(
                        accentColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      category.name.extractWords(maxSize: 8),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
