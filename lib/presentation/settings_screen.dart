import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/account_settings_screen.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/display_settings_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/bottom_sheets/about_app_bottom_sheet.dart';
import 'package:trakli/presentation/utils/bottom_sheets/pick_group_bottom_sheet.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final groups = context.watch<GroupCubit>().state.groups;
    final defaultGroupId =
        context.watch<OnboardingCubit>().state.entity?.defaultGroup;
    final group =
        groups.firstWhereOrNull((entity) => entity.clientId == defaultGroupId);

    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const CustomBackButton(),
        titleText: LocaleKeys.settings.tr(),
        headerTextColor: const Color(0xFFEBEDEC),
        actions: [
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                AppNavigator.push(context, const DisplaySettingsScreen());
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.display_settings,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(LocaleKeys.display.tr()),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    showCurrencyPicker(
                      context: context,
                      theme: CurrencyPickerThemeData(
                        bottomSheetHeight: 0.7.sh,
                        backgroundColor: Colors.white,
                        flagSize: 24.sp,
                        subtitleTextStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onSelect: (Currency currencyValue) {
                        context
                            .read<OnboardingCubit>()
                            .selectCurrency(currencyValue);
                      },
                    );
                  },
                  leading: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    ),
                    child: Icon(
                      Icons.currency_exchange,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(LocaleKeys.defaultCurrency.tr()),
                  subtitle: state.entity?.selectedCurrency != null
                      ? Text(
                          state.entity?.selectedCurrency?.code ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : null,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                _showLanguageSelectionBottomSheet(context);
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.language,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                getLanguageFromCode(context.locale),
              ),
              trailing: Row(
                spacing: 8.w,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryFlag.fromLanguageCode(
                    shape: RoundedRectangle(8.r),
                    context.locale.languageCode,
                    width: 24.w,
                    height: 22.h,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8.h),
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: SvgPicture.asset(
                  Assets.images.people,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(LocaleKeys.switchDefaultGroup.tr()),
              subtitle: Text(
                group?.name ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onTap: groups.length > 1
                  ? () async {
                      final pickedGroup =
                          await showCustomBottomSheet<GroupEntity>(
                        context,
                        widget: PickGroupBottomSheet(
                          group: group,
                        ),
                      );
                      if (pickedGroup != null) {
                        if (context.mounted) {
                          context
                              .read<OnboardingCubit>()
                              .setDefaultGroup(pickedGroup.clientId);
                        }
                      }
                    }
                  : null,
              trailing: groups.length > 1
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                    )
                  : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                AppNavigator.push(context, const AccountSettingsScreen());
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(LocaleKeys.accountAndPrivacy.tr()),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                showCustomBottomSheet(
                  context,
                  widget: const AboutAppBottomSheet(),
                );
              },
              leading: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(LocaleKeys.about.tr()),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelectionBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CupertinoActionSheet(
            title: Text(LocaleKeys.selectLanguage.tr()),
            actions: List.generate(
              supportedLanguages.length,
              (index) => CupertinoActionSheetAction(
                onPressed: () {
                  updateLanguage(context, supportedLanguages.elementAt(index));
                  final configCubit = context.read<ConfigCubit>();
                  configCubit.saveConfig(
                    key: ConfigConstants.defaultLang,
                    type: ConfigType.string,
                    value: context.locale.languageCode,
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  getLanguageFromCode(
                    supportedLanguages.elementAt(index),
                  ),
                  style: TextStyle(
                    color: supportedLanguages.elementAt(index).languageCode ==
                            context.locale.languageCode
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
