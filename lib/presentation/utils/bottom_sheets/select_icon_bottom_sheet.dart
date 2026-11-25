import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

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
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          14.lx,
          8.lx,
          14.lx,
          MediaQuery.of(context).viewInsets.bottom + 12.lx,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LedgerSheetHandle(),
            SizedBox(height: 10.lx),
            if (selectedIconType == null)
              chooseSelector(context)
            else if (selectedIconType ==
                SelectIconType.selectFromGalleryOrCamera)
              selectFromGalleryOrCamera(context)
            else if (selectedIconType == SelectIconType.selectEmoji)
              selectEmoji(context)
            else
              selectIcon(context),
          ],
        ),
      ),
    );
  }

  Widget _header(String title, {bool back = true}) {
    final t = context.tones;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.lx),
      child: Row(
        children: [
          if (back) ...[
            LedgerIconButton(
              icon: LucideIcons.chevronLeft,
              onTap: () => setState(() => selectedIconType = null),
            ),
            SizedBox(width: 10.lx),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 17.lx,
              fontWeight: FontWeight.w700,
              color: t.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseSelector(BuildContext context) {
    Widget option(IconData icon, String label, SelectIconType type,
        {bool divider = true}) {
      return LedgerRow(
        leading: LedgerCoin(icon: icon),
        title: label,
        divider: divider,
        trailing: Icon(
          LucideIcons.chevronRight,
          size: 16.lx,
          color: context.tones.textMuted,
        ),
        onTap: () => setState(() => selectedIconType = type),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(LocaleKeys.selectIcon.tr(), back: false),
        option(LucideIcons.shapes, LocaleKeys.selectIcon.tr(),
            SelectIconType.selectIcon),
        option(LucideIcons.smile, LocaleKeys.useEmoji.tr(),
            SelectIconType.selectEmoji),
        option(LucideIcons.image, LocaleKeys.selectPhoto.tr(),
            SelectIconType.selectFromGalleryOrCamera,
            divider: false),
      ],
    );
  }

  Widget selectFromGalleryOrCamera(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(LocaleKeys.selectPhoto.tr()),
        LedgerRow(
          leading: const LedgerCoin(icon: LucideIcons.camera),
          title: LocaleKeys.camera.tr(),
          onTap: () async {
            final pickedFile = await pickImageApp(
              sourcePick: ImageSource.camera,
              skipCrop: false,
            );
            if (context.mounted) AppNavigator.pop(context, pickedFile);
          },
        ),
        LedgerRow(
          leading: const LedgerCoin(icon: LucideIcons.images),
          title: LocaleKeys.gallery.tr(),
          divider: false,
          onTap: () async {
            final pickedFile = await pickImageApp();
            if (context.mounted) AppNavigator.pop(context, pickedFile);
          },
        ),
      ],
    );
  }

  Widget selectEmoji(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(LocaleKeys.selectEmoji.tr()),
        EmojiPicker(
          onEmojiSelected: (Category? category, Emoji emoji) {
            widget.onSelect?.call(MediaType.emoji, emoji.emoji);
            AppNavigator.pop(context, emoji);
          },
          config: Config(
            height: 340.h,
            locale: context.locale,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 28.sp *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
              columns: 7,
              backgroundColor: context.tones.bgSurface,
              verticalSpacing: 6.h,
              horizontalSpacing: 6.w,
              buttonMode: foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? ButtonMode.CUPERTINO
                  : ButtonMode.MATERIAL,
            ),
            skinToneConfig: SkinToneConfig(
              dialogBackgroundColor: Theme.of(context).colorScheme.surface,
              indicatorColor: Theme.of(context).colorScheme.onSurface,
            ),
            categoryViewConfig: CategoryViewConfig(
              tabBarHeight: 46.h,
              initCategory: Category.SMILEYS,
              backgroundColor: Theme.of(context).colorScheme.surface,
              indicatorColor: context.tones.brandFill,
              iconColorSelected: context.tones.brandText,
              iconColor: context.tones.textMuted,
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
                      prefixIcon: Icon(
                        LucideIcons.search,
                        size: 16.lx,
                        color: context.tones.textMuted,
                      ),
                    ),
                  ),
                );
              },
            ),
            searchViewConfig: SearchViewConfig(
              backgroundColor: context.tones.bgSurface,
              hintText: LocaleKeys.searchEmoji.tr(),
              buttonIconColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget selectIcon(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(LocaleKeys.selectIcon.tr()),
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
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  color: context.tones.surface2,
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.onSelect?.call(MediaType.icon, icon.name);
                    AppNavigator.pop(context);
                  },
                  child: HeroIcon(
                    icon,
                    size: 22.lx,
                    style: HeroIconStyle.outline,
                    color: context.tones.brandText,
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
