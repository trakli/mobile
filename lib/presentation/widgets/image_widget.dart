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
    this.selectedIcon,
    this.accentColor,
    this.iconSize,
    this.emojiSize,
    this.placeholderSize,
    this.placeholderIcon,
    this.placeholderImageAsset,
  });

  final MediaEntity? mediaEntity;
  final IconData? selectedIcon;
  final Color? accentColor;
  final double? iconSize;
  final double? emojiSize;
  final double? placeholderSize;
  final IconData? placeholderIcon;
  final String? placeholderImageAsset;
  // final AddCategoryForm widget;

  @override
  Widget build(BuildContext context) {
    switch (mediaEntity?.mediaType) {
      case null:
      case MediaType.image:
        return placeholderIcon != null
            ? Icon(
                placeholderIcon,
                size: placeholderSize,
                color: accentColor ?? Theme.of(context).primaryColor,
              )
            : Stack(
                children: [
                  Center(
                      child: SvgPicture.asset(
                    placeholderImageAsset ?? Assets.images.category,
                    height: placeholderSize,
                    width: placeholderSize,
                    colorFilter: ColorFilter.mode(
                      accentColor ?? Theme.of(context).primaryColor,
                      BlendMode.srcIn,
                    ),
                  )),
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
          mediaEntity!.content ?? 'Ca',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: iconSize ?? 40.sp,
          ),
        );
      case MediaType.icon:
        return HeroIcon(
          HeroIcons.values.firstWhere(
            (e) => e.name == mediaEntity!.content,
            orElse: () => HeroIcons.questionMarkCircle, // default fallback
          ),
          size: emojiSize ?? 40.sp,
          style: HeroIconStyle.solid,
          color: accentColor ?? Theme.of(context).primaryColor,
        );
    }
  }
}
