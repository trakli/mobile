import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {super.key,
      required this.categories,
      required this.accentColor,
      this.iconSize,
      this.emojiSize,
      this.placeholderSize});

  final List<CategoryEntity> categories;
  final Color accentColor;
  final double? iconSize;
  final double? emojiSize;
  final double? placeholderSize;

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
                    ImageWidget(
                      mediaEntity: category.media,
                      accentColor: accentColor,
                      selectedIcon: null,
                      iconSize: iconSize ?? 12.sp,
                      emojiSize: emojiSize ?? 12.sp,
                      placeholderSize: placeholderSize ?? 12.sp,
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
