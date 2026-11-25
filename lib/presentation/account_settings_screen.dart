import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/data_deletion_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(title: LocaleKeys.accountAndPrivacy.tr()),
      body: LedgerSettingsList(
        children: [
          LedgerSettingsGroup(
            children: [
              LedgerSettingsRow(
                icon: LucideIcons.trash2,
                title: LocaleKeys.data.tr(),
                subtitle: LocaleKeys.dataDeletionOptions.tr(),
                destructive: true,
                onTap: () =>
                    AppNavigator.push(context, const DataDeletionScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
