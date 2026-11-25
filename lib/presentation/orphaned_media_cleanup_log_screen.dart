import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/core/services/orphaned_media_cleanup_service.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

/// Debug-only screen that shows the last orphaned media cleanup log content.
class OrphanedMediaCleanupLogScreen extends StatelessWidget {
  const OrphanedMediaCleanupLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Scaffold(
      backgroundColor: t.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.orphanedMediaCleanupLog.tr(),
      ),
      body: FutureBuilder<String?>(
        future: getOrphanedMediaCleanupLogContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final content = snapshot.data;
          if (content == null || content.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.lx),
                child: Text(
                  LocaleKeys.orphanedMediaCleanupLogEmpty.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.lx, color: t.textMuted),
                ),
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
            children: [
              LedgerCard(
                child: SelectableText(
                  content,
                  style: LedgerText.money(size: 11.lx, color: t.textPrimary),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
