import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/forms/profile_form.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    String orNotSet(String? v) =>
        (v == null || v.trim().isEmpty) ? LocaleKeys.notSet.tr() : v;
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.accountInfo.tr(),
        actions: [
          PageAppBarAction(
            icon: isEditing ? LucideIcons.x : LucideIcons.pencil,
            tooltip: isEditing
                ? LocaleKeys.cancel.tr()
                : LocaleKeys.editInfos.tr(),
            onTap: () => setState(() => isEditing = !isEditing),
          ),
        ],
      ),
      body: isEditing
          ? SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
              child: const ProfileForm(),
            )
          : LedgerSettingsList(
              children: [
                LedgerSettingsGroup(
                  children: [
                    LedgerSettingsRow(
                      icon: LucideIcons.user,
                      title: LocaleKeys.firstName.tr(),
                      value: orNotSet(user?.firstName),
                    ),
                    LedgerSettingsRow(
                      icon: LucideIcons.user,
                      title: LocaleKeys.lastName.tr(),
                      value: orNotSet(user?.lastName),
                    ),
                    LedgerSettingsRow(
                      icon: LucideIcons.mail,
                      title: LocaleKeys.email.tr(),
                      value: orNotSet(user?.email),
                    ),
                    LedgerSettingsRow(
                      icon: LucideIcons.phone,
                      title: LocaleKeys.phoneNumber.tr(),
                      value: orNotSet(user?.phone),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
