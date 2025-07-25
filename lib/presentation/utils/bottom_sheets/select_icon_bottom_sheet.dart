import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';

class SelectIconBottomSheet extends StatefulWidget {
  const SelectIconBottomSheet({
    super.key,
    this.onSelect,
  });

  final void Function(MediaType mediaType, String image)? onSelect;

  @override
  State<SelectIconBottomSheet> createState() => _SelectIconBottomSheetState();
}

class _SelectIconBottomSheetState extends State<SelectIconBottomSheet> {
  SelectIconType? selectedIconType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Align(
            child: Container(
              width: 90.w,
              height: 6.h,
              decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(height: 16.h),
          if (selectedIconType == null)
            chooseSelector(context)
          else if (selectedIconType == SelectIconType.selectFromGalleryOrCamera)
            selectFromGalleryOrCamera(context)
          else if (selectedIconType == SelectIconType.selectEmoji)
            selectEmoji(context)
          else
            selectIcon(context),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget chooseSelector(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.selectIcon.tr(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 16.h),
        GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
          ),
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIconType = SelectIconType.selectFromGalleryOrCamera;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF01190E),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.h,
                  children: [
                    SvgPicture.asset(
                      width: 32.w,
                      height: 32.h,
                      Assets.images.camera,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      LocaleKeys.selectPhoto.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIconType = SelectIconType.selectEmoji;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.h,
                  children: [
                    SizedBox(
                      width: 32.w,
                      height: 32.h,
                      child: Center(
                        child: Text(
                          "😃",
                          style: TextStyle(
                            fontSize: 22.sp,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      LocaleKeys.useEmoji.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedIconType = SelectIconType.selectIcon;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.h,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 32.r,
                    ),
                    Text(
                      LocaleKeys.selectIcon.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget selectFromGalleryOrCamera(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16.w,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedIconType = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: backButtonColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  width: 24.w,
                  height: 24.w,
                  Assets.images.arrowLeft,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Text(
              LocaleKeys.selectPhoto.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          spacing: 0.25.sw,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              spacing: 4.h,
              children: [
                GestureDetector(
                  onTap: () async {
                    File? pickedFile = await pickImageApp(
                      sourcePick: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      AppNavigator.pop(context, pickedFile);
                    }
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: Theme.of(context).primaryColor,
                      size: 20.sp,
                    ),
                  ),
                ),
                Text(
                  LocaleKeys.camera.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Column(
              spacing: 4.h,
              children: [
                GestureDetector(
                  onTap: () async {
                    File? pickedFile = await pickImageApp();
                    if (pickedFile != null) {
                      AppNavigator.pop(context, pickedFile);
                    }
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      FontAwesomeIcons.photoFilm,
                      color: Theme.of(context).primaryColor,
                      size: 20.sp,
                    ),
                  ),
                ),
                Text(
                  LocaleKeys.gallery.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        // SizedBox(height: 16.h),
      ],
    );
  }

  Widget selectEmoji(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16.w,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedIconType = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: backButtonColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  width: 24.w,
                  height: 24.w,
                  Assets.images.arrowLeft,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Text(
              LocaleKeys.selectEmoji.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        EmojiPicker(
          onEmojiSelected: (Category? category, Emoji emoji) {
            widget.onSelect?.call(MediaType.emoji, emoji.emoji);
            AppNavigator.pop(context, emoji);
          },
          config: Config(
            height: 340.h,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 28.sp *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
              columns: 7,
              backgroundColor: emojiBackgroundColor,
              verticalSpacing: 6.h,
              horizontalSpacing: 6.w,
              buttonMode: foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? ButtonMode.CUPERTINO
                  : ButtonMode.MATERIAL,
            ),
            skinToneConfig: const SkinToneConfig(),
            categoryViewConfig: CategoryViewConfig(
              tabBarHeight: 46.h,
              initCategory: Category.SMILEYS,
              backgroundColor: emojiBackgroundColor,
              indicatorColor: Theme.of(context).primaryColor,
              iconColorSelected: Theme.of(context).primaryColor,
              iconColor: Colors.grey.shade400,
              categoryIcons: const CategoryIcons(
                recentIcon: FontAwesomeIcons.clock,
                smileyIcon: FontAwesomeIcons.faceSmile,
                animalIcon: FontAwesomeIcons.paw,
                flagIcon: FontAwesomeIcons.flag,
                travelIcon: FontAwesomeIcons.city,
                activityIcon: FontAwesomeIcons.personRunning,
                objectIcon: FontAwesomeIcons.lightbulb,
              ),
            ),
            viewOrderConfig: const ViewOrderConfig(
              top: EmojiPickerItem.searchBar,
              middle: EmojiPickerItem.emojiView,
              bottom: EmojiPickerItem.categoryBar,
            ),
            bottomActionBarConfig: BottomActionBarConfig(
              customBottomActionBar: (config, state, showSearchView) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    readOnly: true,
                    onTap: showSearchView,
                    onChanged: (val) {},
                    decoration: InputDecoration(
                      hintText: LocaleKeys.searchEmoji.tr(),
                      fillColor: Colors.white,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          Assets.images.searchSpecial,
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            searchViewConfig: SearchViewConfig(
              backgroundColor: emojiBackgroundColor,
              hintText: LocaleKeys.searchEmoji.tr(),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectIcon(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16.w,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedIconType = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: backButtonColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  width: 24.w,
                  height: 24.w,
                  Assets.images.arrowLeft,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Text(
              LocaleKeys.selectIcon.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          constraints: BoxConstraints(
            maxHeight: 340.h,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
            ),
            itemCount: heroIconsCategories.length,
            itemBuilder: (context, index) {
              final icon = heroIconsCategories[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withAlpha(50),
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.onSelect?.call(MediaType.icon, icon.name);
                    AppNavigator.pop(context);
                  },
                  child: HeroIcon(
                    icon,
                    size: 28.sp,
                    style: HeroIconStyle.solid,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
