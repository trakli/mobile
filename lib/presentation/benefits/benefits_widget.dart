import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/error/failures/failures.dart' show Failure;
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/usecases/sync/check_pending_changes_usecase.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/auth/pages/login_screen.dart';
import 'package:trakli/presentation/auth/pages/register_screen.dart';
import 'package:trakli/presentation/benefits/cubit/benefits_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showSnackBar, showCustomDialog;

class BenefitsWidget extends StatelessWidget {
  const BenefitsWidget({super.key});

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
          // Show warning dialog with create account option
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
          AppNavigator.pop(context);
          // Logout will trigger the BlocListener in app_widget.dart
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
        secondaryActionText: LocaleKeys.createAccountNow.tr(),
        buttonLayout: ButtonLayout.vertical,
        mainAction: () {
          // Logout anyway - clear data and sign out
          AppNavigator.pop(context);
          // Logout will trigger the BlocListener in app_widget.dart
          context.read<AuthCubit>().logout();
        },
        secondaryAction: () {
          // Create account - navigate to register screen
          AppNavigator.pop(context);
          AppNavigator.removeAllPreviousAndPushThenPush(
            context,
            const LoginScreen(),
            const RegisterScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BenefitsCubit, BenefitsState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          showSnackBar(
            message: state.failure.customMessage,
            borderRadius: 8.r,
          );
        }
      },
      builder: (context, state) {
        final benefits = state.cloudBenefits?.benefits ?? [];

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final t = context.tones;
        final overview = state.cloudBenefits?.overview;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LedgerCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.dontHaveAccount.tr(),
                    style: TextStyle(
                      fontSize: 16.lx,
                      fontWeight: FontWeight.w700,
                      color: t.textPrimary,
                    ),
                  ),
                  if (overview?.description.isNotEmpty == true) ...[
                    SizedBox(height: 6.lx),
                    Text(
                      overview!.description,
                      style: TextStyle(
                        fontSize: 12.5.lx,
                        height: 1.45,
                        color: t.textSecondary,
                      ),
                    ),
                  ],
                  if (overview?.title.isNotEmpty == true) ...[
                    SizedBox(height: 12.lx),
                    LedgerH6(overview!.title),
                  ],
                  for (final b in benefits)
                    LedgerRow(
                      leading: Icon(
                        LucideIcons.check,
                        size: 16.lx,
                        color: t.brandText,
                      ),
                      title: b.title,
                      subtitle: b.description,
                      divider: b != benefits.last,
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.lx),
            LedgerButton(
              label: LocaleKeys.createAccountNow.tr(),
              large: true,
              onPressed: () => AppNavigator.removeAllPreviousAndPushThenPush(
                context,
                const LoginScreen(),
                const RegisterScreen(),
              ),
            ),
            SizedBox(height: 8.lx),
            LedgerButton(
              label: LocaleKeys.logOut.tr(),
              icon: LucideIcons.logOut,
              large: true,
              style: LedgerButtonStyle.outline,
              foreground: t.expenseColor,
              onPressed: () => _handleLogout(context),
            ),
          ],
        );
      },
    );
  }
}
