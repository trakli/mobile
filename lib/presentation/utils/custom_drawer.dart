import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/presentation/ai_chat/widgets/trakli_mark.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/financial_position/financial_position_screen.dart';
import 'package:trakli/presentation/groups/my_groups_screen.dart';
import 'package:trakli/presentation/holdings/cubit/holding_cubit.dart';
import 'package:trakli/presentation/holdings/holdings_screen.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/imports/import_hub_screen.dart';
import 'package:trakli/presentation/parties/party_screen.dart';
import 'package:trakli/presentation/profile_screen.dart';
import 'package:trakli/presentation/reminders/reminder_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/settings_screen.dart';
import 'package:trakli/presentation/transfers/transfers_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/premium_tile.dart';
import 'package:trakli/presentation/widgets/database_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _launchSupportEmail(BuildContext context) async {
    final supportEmail = LocaleKeys.supportEmail.tr();
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {
        'subject': LocaleKeys.supportEmailSubject.tr(),
      },
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        await _copyEmailAndShowSnackbar(context, supportEmail);
      }
    } catch (e) {
      if (context.mounted) {
        await _copyEmailAndShowSnackbar(context, supportEmail);
      }
    }
  }

  Future<void> _copyEmailAndShowSnackbar(
      BuildContext context, String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              LocaleKeys.supportEmailCopied.tr().replaceFirst('{0}', email)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final user = context.watch<AuthCubit>().state.user;
    final name = user?.fullName.trim();
    final displayName =
        (name == null || name.isEmpty) ? LocaleKeys.defaultUserName.tr() : name;

    void push(Widget screen) => AppNavigator.push(context, screen);

    return Container(
      color: t.bgPage,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.lx, 14.lx, 16.lx, 10.lx),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: TrakliLogo(height: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.lx),
            child: LedgerCard(
              padding: EdgeInsets.all(10.lx),
              onTap: () => push(const ProfileScreen()),
              child: Row(
                children: [
                  LedgerInitials(
                    displayName.isNotEmpty ? displayName : (user?.email ?? '?'),
                    size: 34,
                  ),
                  SizedBox(width: 10.lx),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5.lx,
                            fontWeight: FontWeight.w600,
                            color: t.textPrimary,
                          ),
                        ),
                        if (user?.email != null)
                          Text(
                            user!.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.lx,
                              color: t.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 16.lx,
                    color: t.textMuted,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ListView(
                padding: EdgeInsets.fromLTRB(10.lx, 6.lx, 10.lx, 16.lx),
                children: [
                  _DrawerSection(LocaleKeys.drawerEveryday.tr()),
                  _DrawerItem(
                    icon: LucideIcons.receiptText,
                    label: LocaleKeys.transactions.tr(),
                    onTap: () => push(const HistoryScreen()),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.wallet,
                    label: LocaleKeys.wallets.tr(),
                    onTap: () {
                      context
                          .read<MainNavigationCubit>()
                          .updateIndex(MainNavigationPageState.wallet);
                      AppNavigator.pop(context);
                    },
                  ),
                  _DrawerItem(
                    icon: LucideIcons.usersRound,
                    label: LocaleKeys.parties.tr(),
                    onTap: () => push(const PartyScreen()),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.tag,
                    label: LocaleKeys.categories.tr(),
                    onTap: () => push(const CategoryScreen()),
                  ),
                  _DrawerSection(LocaleKeys.drawerOrganize.tr()),
                  _DrawerItem(
                    icon: LucideIcons.arrowLeftRight,
                    label: LocaleKeys.transfers.tr(),
                    onTap: () => push(const TransfersScreen()),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.folder,
                    label: LocaleKeys.groups.tr(),
                    onTap: () => push(const MyGroupsScreen()),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.scale,
                    label: LocaleKeys.fpSectionTitle.tr(),
                    onTap: () => push(const FinancialPositionScreen()),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.coins,
                    label: LocaleKeys.holdingsTitle.tr(),
                    onTap: () => push(
                      BlocProvider(
                        create: (_) => getIt<HoldingCubit>(),
                        child: const HoldingsScreen(),
                      ),
                    ),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.bellRing,
                    label: LocaleKeys.reminders.tr(),
                    onTap: () => push(const ReminderScreen()),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.fileUp,
                    label: LocaleKeys.imports.tr(),
                    onTap: () => push(const ImportHubScreen()),
                  ),
                  _DrawerSection(LocaleKeys.drawerMore.tr()),
                  _DrawerItem(
                    icon: LucideIcons.settings,
                    label: LocaleKeys.settings.tr(),
                    onTap: () => push(const SettingsScreen()),
                  ),
                  _DrawerItem(
                    icon: LucideIcons.lifeBuoy,
                    label: LocaleKeys.support.tr(),
                    onTap: () => _launchSupportEmail(context),
                  ),
                  BlocBuilder<ConfigCubit, ConfigState>(
                    builder: (context, state) {
                      if (!kDebugMode && state.showDebug != true) {
                        return const SizedBox.shrink();
                      }
                      return _DrawerItem(
                        icon: LucideIcons.database,
                        label: LocaleKeys.databaseViewer.tr(),
                        muted: true,
                        onTap: () => push(DatabaseViewer(database: getIt())),
                      );
                    },
                  ),
                  SizedBox(height: 12.lx),
                  const PremiumTile(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerSection extends StatelessWidget {
  final String text;

  const _DrawerSection(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.lx, 16.lx, 8.lx, 4.lx),
      child: LedgerH6(text),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool muted;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadii.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.lx, vertical: 9.lx),
          child: Row(
            children: [
              Icon(icon, size: 17.lx, color: t.textSecondary),
              SizedBox(width: 12.lx),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.lx,
                    fontWeight: FontWeight.w500,
                    color: muted ? t.textMuted : t.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
