import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/orphaned_media_cleanup_log_screen.dart';
import 'package:trakli/presentation/sync_history_screen.dart';

class AdvancedSettingsScreen extends StatelessWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(title: LocaleKeys.advanced.tr()),
      body: LedgerSettingsList(
        children: [
          LedgerSettingsGroup(
            children: [
              LedgerSettingsRow(
                icon: LucideIcons.refreshCw,
                title: LocaleKeys.synchronization.tr(),
                subtitle: LocaleKeys.syncHistoryDesc.tr(),
                onTap: () =>
                    AppNavigator.push(context, const SyncHistoryScreen()),
              ),
              if (kDebugMode)
                LedgerSettingsRow(
                  icon: LucideIcons.folderOpen,
                  title: LocaleKeys.orphanedMediaCleanupLog.tr(),
                  subtitle: LocaleKeys.orphanedMediaCleanupLogDesc.tr(),
                  onTap: () => AppNavigator.push(
                    context,
                    const OrphanedMediaCleanupLogScreen(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
