import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/account_deletion_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class DataDeletionScreen extends StatefulWidget {
  const DataDeletionScreen({super.key});

  @override
  State<DataDeletionScreen> createState() => _DataDeletionScreenState();
}

class _DataDeletionScreenState extends State<DataDeletionScreen> {
  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final body = TextStyle(
      fontSize: 13.5.lx,
      height: 1.5,
      color: t.textSecondary,
    );
    return Scaffold(
      backgroundColor: t.bgPage,
      appBar: PageAppBar(title: LocaleKeys.data.tr()),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
        children: [
          Text(
            LocaleKeys.dataDeletionOptions.tr(),
            style: TextStyle(
              fontSize: 17.lx,
              fontWeight: FontWeight.w700,
              color: t.textPrimary,
            ),
          ),
          SizedBox(height: 10.lx),
          Text(LocaleKeys.dataDeletionDescription.tr(), style: body),
          SizedBox(height: 10.lx),
          Text(LocaleKeys.dataDeletionRemoteDescription.tr(), style: body),
          SizedBox(height: 16.lx),
          LedgerCard(
            color: t.expense.background,
            borderColor: t.expenseColor.withValues(alpha: 0.35),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.triangleAlert,
                  size: 16.lx,
                  color: t.expenseColor,
                ),
                SizedBox(width: 10.lx),
                Expanded(
                  child: Text(
                    LocaleKeys.dataDeletionWarning.tr(),
                    style: TextStyle(
                      fontSize: 12.5.lx,
                      height: 1.45,
                      color: t.expenseColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.lx),
          LedgerButton(
            label: LocaleKeys.requestDataDeletion.tr(),
            icon: LucideIcons.trash2,
            large: true,
            background: t.expenseColor,
            foreground: Colors.white,
            onPressed: () => _showSelfDeleteWarning(context),
          ),
        ],
      ),
    );
  }

  void _showSelfDeleteWarning(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        title: LocaleKeys.deleteYourAccount.tr(),
        subTitle: LocaleKeys.deleteAccountDesc.tr(),
        dialogType: DialogType.negative,
        mainAction: () async {
          final authState = context.read<AuthCubit>().state;
          final user = authState.user;
          if (user != null) {
            final reason = await showCustomBottomSheet<String>(
              context,
              color: context.tones.bgSurface,
              widget: const AccountDeletionSheet(),
            );
            if (context.mounted) {
              AppNavigator.pop(context);
              context.read<AuthCubit>().deleteAccount(reason: reason);
            }
          } else {
            AppNavigator.pop(context);
          }
        },
      ),
    );
  }
}
