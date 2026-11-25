import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/widgets/trakli_mark.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class AboutAppBottomSheet extends StatelessWidget {
  const AboutAppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 14.lx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LedgerSheetHandle(),
            SizedBox(height: 14.lx),
            Row(
              children: [
                const TrakliLogo(height: 28),
                const Spacer(),
                BlocConsumer<ConfigCubit, ConfigState>(
                  listenWhen: (previous, current) =>
                      previous.showDebug != current.showDebug,
                  listener: (context, state) {
                    if (state.showDebug == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(LocaleKeys.aboutDebugOn.tr())),
                      );
                    }
                  },
                  builder: (context, state) => GestureDetector(
                    onTap: context.read<ConfigCubit>().handleDebugTap,
                    child: LedgerChip(
                      LocaleKeys.aboutVersion
                          .tr(args: [state.appVersion ?? '']),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.lx),
            Text(
              LocaleKeys.aboutAppDescription.tr(),
              style: TextStyle(
                fontSize: 13.5.lx,
                height: 1.5,
                color: t.textPrimary,
              ),
            ),
            SizedBox(height: 8.lx),
            Text(
              LocaleKeys.openSourceProject.tr(),
              style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
            ),
            SizedBox(height: 12.lx),
            LedgerSettingsGroup(
              children: [
                LedgerSettingsRow(
                  icon: LucideIcons.codeXml,
                  title: LocaleKeys.viewOnGithub.tr(),
                  trailing: Icon(
                    LucideIcons.externalLink,
                    size: 14.lx,
                    color: t.textMuted,
                  ),
                  onTap: () => openUrl(url: "https://github.com/trakli"),
                ),
                LedgerSettingsRow(
                  icon: LucideIcons.shield,
                  title: LocaleKeys.privacyPolicy.tr(),
                  trailing: Icon(
                    LucideIcons.externalLink,
                    size: 14.lx,
                    color: t.textMuted,
                  ),
                  onTap: () => openUrl(url: "https://trakli.app/privacy"),
                ),
                LedgerSettingsRow(
                  icon: LucideIcons.fileText,
                  title: LocaleKeys.termsAndConditions.tr(),
                  trailing: Icon(
                    LucideIcons.externalLink,
                    size: 14.lx,
                    color: t.textMuted,
                  ),
                  onTap: () => openUrl(url: "https://trakli.app/terms"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
