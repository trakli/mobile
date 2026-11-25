import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/plans/cubit/plans_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/premium_dialog.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/helpers.dart'
    show showCustomDialog, showSnackBar;

class PremiumTile extends StatelessWidget {
  const PremiumTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlansCubit, PlansState>(
      listener: (context, state) {
        // Show error message for any failure except notFound
        if (state.failure != const Failure.none() &&
            !state.failure.maybeWhen(
              notFound: () => true,
              orElse: () => false,
            )) {
          showSnackBar(
            message: state.failure.customMessage,
            borderRadius: 8.r,
          );
        }
      },
      builder: (context, state) {
        // Hide completely if failure is notFound
        if (state.failure.maybeWhen(
          notFound: () => true,
          orElse: () => false,
        )) {
          return const SizedBox.shrink();
        }

        if (state.isLoading) {
          return const SizedBox.shrink();
        }

        final subscription = state.subscription;
        if (subscription != null) {
          final t = context.tones;
          return LedgerCard(
            color: t.accentWarmSoft,
            borderColor: t.accentWarm.withValues(alpha: 0.45),
            padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 10.lx),
            onTap: () => showCustomDialog(
              widget: PremiumDialog(subscription: subscription),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.gem, size: 18.lx, color: t.accentWarm),
                SizedBox(width: 10.lx),
                Expanded(
                  child: Text(
                    LocaleKeys.upgradeToPremium.tr(),
                    style: TextStyle(
                      fontSize: 14.lx,
                      fontWeight: FontWeight.w600,
                      color: t.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16.lx,
                  color: t.accentWarm,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
