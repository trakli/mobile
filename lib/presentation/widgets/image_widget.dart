import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:heroicons/heroicons.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/enums.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.mediaEntity,
    required this.selectedIcon,
    this.accentColor,
    this.iconSize,
    this.emojiSize,
    this.placeholderSize,
  });

  final MediaEntity? mediaEntity;
  final IconData? selectedIcon;
  final Color? accentColor;
  final double? iconSize;
  final double? emojiSize;
  final double? placeholderSize;
  // final AddCategoryForm widget;

  @override
  Widget build(BuildContext context) {
    switch (mediaEntity?.mediaType) {
      case null:
      case MediaType.image:
        return Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                Assets.images.camera,
                height: placeholderSize,
                width: placeholderSize,
                colorFilter: ColorFilter.mode(
                  accentColor ?? Theme.of(context).primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              right: 10.w,
              bottom: 10.h,
              child: Icon(
                selectedIcon ?? Icons.category,
                color: accentColor,
                size: 20.r,
              ),
            ),
          ],
        );
      case MediaType.emoji:
        return Text(
          mediaEntity!.image,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: iconSize ?? 40.sp,
          ),
        );
      case MediaType.icon:
        return HeroIcon(
          HeroIcons.values.firstWhere(
            (e) => e.name == mediaEntity!.image,
            orElse: () => HeroIcons.questionMarkCircle, // default fallback
          ),
          // mediaEntity!.image,
          size: emojiSize ?? 40.sp,
          style: HeroIconStyle.solid,
          color: Theme.of(context).primaryColor,
        );
    }
  }
}
