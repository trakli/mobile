import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/usecases/sync/check_pending_changes_usecase.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/account_info_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/benefits/benefits_widget.dart';
import 'package:trakli/presentation/settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/premium_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Check for pending changes
    final checkPendingChangesUsecase = getIt<CheckPendingChangesUsecase>();
    final result = await checkPendingChangesUsecase(NoParams());

    result.fold(
      (failure) {
        // If there's an error checking pending changes, show regular logout dialog
        _showLogoutDialog(context);
      },
      (hasPendingChanges) {
        if (hasPendingChanges) {
          // Show warning dialog with sync option
          _showLogoutWarningDialog(context);
        } else {
          // No pending changes, show regular logout dialog
          _showLogoutDialog(context);
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.logOut.tr(),
        subTitle: LocaleKeys.logoutConfirm.tr(),
        dialogType: DialogType.negative,
        mainAction: () {
          context.read<AuthCubit>().logout();
        },
      ),
    );
  }

  void _showLogoutWarningDialog(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.logoutWarningTitle.tr(),
        subTitle: LocaleKeys.logoutWarningMessage.tr(),
        dialogType: DialogType.negative,
        mainActionText: LocaleKeys.logoutAnyway.tr(),
        secondaryActionText: LocaleKeys.syncNow.tr(),
        buttonLayout: ButtonLayout.vertical,
        mainAction: () {
          // Logout anyway
          context.read<AuthCubit>().logout();
        },
        secondaryAction: () {
          // Sync now
          getIt<SynchAppDatabase>().sync();
          AppNavigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    final t = context.tones;

    return Scaffold(
      backgroundColor: t.bgPage,
      appBar: PageAppBar(title: LocaleKeys.profile.tr()),
      body: LedgerSettingsList(
        children: [
          LedgerCard(
            onTap: user == null
                ? null
                : () => AppNavigator.push(context, const AccountInfoScreen()),
            child: Row(
              children: [
                LedgerInitials(
                  user?.fullName.trim().isNotEmpty == true
                      ? user!.fullName
                      : '?',
                  size: 48,
                ),
                SizedBox(width: 12.lx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? LocaleKeys.anonymous.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.lx,
                          fontWeight: FontWeight.w700,
                          color: t.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.lx),
                      Text(
                        user?.email ?? LocaleKeys.profileNotSignedIn.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                      ),
                    ],
                  ),
                ),
                if (user != null)
                  Icon(
                    LucideIcons.chevronRight,
                    size: 16.lx,
                    color: t.textMuted,
                  ),
              ],
            ),
          ),
          if (user != null) ...[
            const PremiumTile(),
            LedgerSettingsGroup(
              title: LocaleKeys.profileAccount.tr(),
              children: [
                LedgerSettingsRow(
                  icon: LucideIcons.userRound,
                  title: LocaleKeys.accountInfo.tr(),
                  onTap: () =>
                      AppNavigator.push(context, const AccountInfoScreen()),
                ),
                LedgerSettingsRow(
                  icon: LucideIcons.settings,
                  title: LocaleKeys.settings.tr(),
                  onTap: () =>
                      AppNavigator.push(context, const SettingsScreen()),
                ),
                LedgerSettingsRow(
                  icon: LucideIcons.logOut,
                  title: LocaleKeys.logOut.tr(),
                  destructive: true,
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ] else
            const BenefitsWidget(),
        ],
      ),
    );
  }
}
