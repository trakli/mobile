import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/theme_cubit/theme_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/providers/local_storage.dart';

class DisplaySettingsScreen extends StatefulWidget {
  const DisplaySettingsScreen({super.key});

  @override
  State<DisplaySettingsScreen> createState() => _DisplaySettingsScreenState();
}

class _DisplaySettingsScreenState extends State<DisplaySettingsScreen> {
  String? formDisplay;

  @override
  void initState() {
    getFormDisplay();
    super.initState();
  }

  void getFormDisplay() async {
    await LocalStorage().getTransactionFormDisplay().then((val) {
      setState(() {
        formDisplay = val ?? 'full';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(title: LocaleKeys.displaySettings.tr()),
      body: LedgerSettingsList(
        children: [
          LedgerSettingsGroup(
            children: [
              LedgerSettingsRow(
                icon: LucideIcons.panelsTopLeft,
                title: LocaleKeys.transactionFormDisplayMode.tr(),
                value: formDisplay == null
                    ? null
                    : getFormDisplayText(formDisplay!),
                onTap: () => _pickFormDisplay(context),
              ),
              LedgerSettingsRow(
                icon: LucideIcons.sunMoon,
                title: LocaleKeys.themeMode.tr(),
                value: mode.name.tr(),
                onTap: () => _pickThemeMode(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFormDisplay(BuildContext context) async {
    final picked = await showLedgerOptionsSheet<String>(
      context,
      title: LocaleKeys.selectFormDisplayMode.tr(),
      selected: formDisplay,
      options: [
        for (final d in supportedFormDisplays)
          LedgerOption(d, getFormDisplayText(d)),
      ],
    );
    if (picked == null) return;
    LocalStorage().updateTransactionFormDisplay(picked);
    if (mounted) setState(() => formDisplay = picked);
  }

  Future<void> _pickThemeMode(BuildContext context) async {
    final themeCubit = context.read<ThemeCubit>();
    final picked = await showLedgerOptionsSheet<ThemeMode>(
      context,
      title: LocaleKeys.selectThemeMode.tr(),
      selected: themeCubit.state,
      options: [
        for (final m in ThemeMode.values)
          LedgerOption(
            m,
            m.name.tr(),
            leading: Icon(
              switch (m) {
                ThemeMode.system => LucideIcons.smartphone,
                ThemeMode.light => LucideIcons.sun,
                ThemeMode.dark => LucideIcons.moon,
              },
              size: 17.lx,
              color: context.tones.textSecondary,
            ),
          ),
      ],
    );
    if (picked != null) themeCubit.updateThemeByEnum(picked);
  }
}
