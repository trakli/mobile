import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/app_update/cubit/in_app_update_cubit.dart';

/// A persistent banner shown when a flexible update has been downloaded
/// and is ready to install. Similar to [SyncIndicatorOverlay].
class UpdateReadyBanner extends StatelessWidget {
  const UpdateReadyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InAppUpdateCubit, InAppUpdateState>(
      builder: (context, state) {
        if (state != InAppUpdateState.ready) {
          return const SizedBox.shrink();
        }

        final t = context.tones;
        return Material(
          color: t.brandFill,
          child: SafeArea(
            top: false,
            child: InkWell(
              onTap: () => _showRestartDialog(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.lx,
                  vertical: 10.lx,
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.download, color: t.onBrand, size: 17.lx),
                    SizedBox(width: 10.lx),
                    Expanded(
                      child: Text(
                        LocaleKeys.appUpdateReadyToInstall.tr(),
                        style: TextStyle(
                          fontSize: 13.5.lx,
                          color: t.onBrand,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: t.onBrand),
                      onPressed: () => context
                          .read<InAppUpdateCubit>()
                          .completeFlexibleUpdate(),
                      child: Text(LocaleKeys.appUpdateRestart.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRestartDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => PopUpDialog(
        title: LocaleKeys.appUpdateReady.tr(),
        subTitle: LocaleKeys.appUpdateRestartPrompt.tr(),
        secondaryActionText: LocaleKeys.appUpdateLater.tr(),
        mainActionText: LocaleKeys.appUpdateRestart.tr(),
        secondaryAction: () => Navigator.of(ctx).pop(),
        mainAction: () {
          Navigator.of(ctx).pop();
          context.read<InAppUpdateCubit>().completeFlexibleUpdate();
        },
      ),
    );
  }
}
