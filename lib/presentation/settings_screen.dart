import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/account_settings_screen.dart';
import 'package:trakli/presentation/advanced_settings_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/defaults_settings_screen.dart';
import 'package:trakli/presentation/display_settings_screen.dart';
import 'package:trakli/presentation/notification_settings/notification_settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/about_app_bottom_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthCubit>().state.isAuthenticated;
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(title: LocaleKeys.settings.tr()),
      body: LedgerSettingsList(
        children: [
          LedgerSettingsGroup(
            children: [
              LedgerSettingsRow(
                icon: LucideIcons.languages,
                title: LocaleKeys.selectLanguage.tr(),
                value: getLanguageFromCode(context.locale),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CountryFlag.fromLanguageCode(
                      context.locale.languageCode,
                      shape: const RoundedRectangle(3),
                      width: 20.lx,
                      height: 14.lx,
                    ),
                    SizedBox(width: 6.lx),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 16.lx,
                      color: context.tones.textMuted,
                    ),
                  ],
                ),
                onTap: () => _pickLanguage(context),
              ),
              LedgerSettingsRow(
                icon: LucideIcons.monitorSmartphone,
                title: LocaleKeys.display.tr(),
                onTap: () => AppNavigator.push(
                  context,
                  const DisplaySettingsScreen(),
                ),
              ),
              LedgerSettingsRow(
                icon: LucideIcons.slidersHorizontal,
                title: LocaleKeys.defaults.tr(),
                subtitle: LocaleKeys.defaultSettingsDesc.tr(),
                onTap: () => AppNavigator.push(
                  context,
                  const DefaultsSettingsScreen(),
                ),
              ),
              if (isAuthenticated)
                LedgerSettingsRow(
                  icon: LucideIcons.bell,
                  title: LocaleKeys.notificationSettings.tr(),
                  onTap: () => AppNavigator.push(
                    context,
                    const NotificationSettingsScreen(),
                  ),
                ),
            ],
          ),
          LedgerSettingsGroup(
            children: [
              LedgerSettingsRow(
                icon: LucideIcons.shieldCheck,
                title: LocaleKeys.accountAndPrivacy.tr(),
                onTap: () => AppNavigator.push(
                  context,
                  const AccountSettingsScreen(),
                ),
              ),
              LedgerSettingsRow(
                icon: LucideIcons.wrench,
                title: LocaleKeys.advanced.tr(),
                onTap: () => AppNavigator.push(
                  context,
                  const AdvancedSettingsScreen(),
                ),
              ),
              LedgerSettingsRow(
                icon: LucideIcons.info,
                title: LocaleKeys.about.tr(),
                onTap: () => showCustomBottomSheet(
                  context,
                  color: context.tones.bgSurface,
                  widget: const AboutAppBottomSheet(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final configCubit = context.read<ConfigCubit>();
    final picked = await showLedgerOptionsSheet<Locale>(
      context,
      title: LocaleKeys.selectLanguage.tr(),
      selected: context.locale,
      options: [
        for (final l in supportedLanguages)
          LedgerOption(
            l,
            getLanguageFromCode(l),
            leading: CountryFlag.fromLanguageCode(
              l.languageCode,
              shape: const RoundedRectangle(3),
              width: 22.lx,
              height: 16.lx,
            ),
          ),
      ],
    );
    if (picked == null || !context.mounted) return;
    updateLanguage(context, picked);
    configCubit.saveConfig(
      key: ConfigConstants.defaultLang,
      type: ConfigType.string,
      value: picked.languageCode,
    );
  }
}
