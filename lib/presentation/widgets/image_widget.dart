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
    this.accentColor,
    this.iconSize,
    this.emojiSize,
    this.placeholderSize,
    this.placeholderIcon,
    this.placeholderImageAsset,
  });

  final MediaEntity? mediaEntity;
  final Color? accentColor;
  final double? iconSize;
  final double? emojiSize;
  final double? placeholderSize;
  final IconData? placeholderIcon;
  final String? placeholderImageAsset;

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
                ],
              );
      case MediaType.emoji:
        return Text(
          mediaEntity!.content ?? 'Ca',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: emojiSize ?? 40.sp,
          ),
        );
      case MediaType.icon:
        return HeroIcon(
          HeroIcons.values.firstWhere(
            (e) => e.name == mediaEntity!.content,
            orElse: () => HeroIcons.questionMarkCircle, // default fallback
          ),
          size: iconSize ?? 40.sp,
          style: HeroIconStyle.solid,
          color: accentColor ?? Theme.of(context).primaryColor,
        );
    }
  }
}
