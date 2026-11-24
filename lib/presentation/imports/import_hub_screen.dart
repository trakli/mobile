import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/imports/cubit/import_cubit.dart';
import 'package:trakli/presentation/imports/document_scan_screen.dart';
import 'package:trakli/presentation/imports/widgets/import_action_card.dart';
import 'package:trakli/presentation/imports/widgets/import_activity_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class ImportHubScreen extends StatefulWidget {
  const ImportHubScreen({super.key});

  @override
  State<ImportHubScreen> createState() => _ImportHubScreenState();
}

class _ImportHubScreenState extends State<ImportHubScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ImportCubit>().loadSessions();
  }

  Future<void> _refresh() async {
    await context.read<ImportCubit>().loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48.lx),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 4.lx),
            child: LedgerScreenBar(
              title: LocaleKeys.imports.tr(),
              leadingIcon: LucideIcons.chevronLeft,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: BlocBuilder<ImportCubit, ImportState>(
            builder: (context, state) {
              final sessions = [...state.sessions]..sort(
                  (a, b) {
                    final aDate = a.updatedAt ??
                        a.createdAt ??
                        DateTime.fromMillisecondsSinceEpoch(0);
                    final bDate = b.updatedAt ??
                        b.createdAt ??
                        DateTime.fromMillisecondsSinceEpoch(0);
                    return bDate.compareTo(aDate);
                  },
                );
              return ListView(
                padding: EdgeInsets.all(14.lx),
                children: [
                  ImportActionCard(
                    icon: LucideIcons.scanLine,
                    title: LocaleKeys.importScanDocument.tr(),
                    subtitle: LocaleKeys.importScanDocumentDesc.tr(),
                    onTap: () => AppNavigator.push(
                      context,
                      const DocumentScanScreen(),
                    ),
                  ),
                  SizedBox(height: 18.lx),
                  LedgerH6(LocaleKeys.importRecentActivity.tr()),
                  SizedBox(height: 6.lx),
                  if (sessions.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Text(
                          LocaleKeys.importNoActivity.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                  else
                    ...sessions.map((s) => ImportActivityTile(session: s)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
