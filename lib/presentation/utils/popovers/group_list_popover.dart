import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_popover.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';

class GroupListPopover extends StatelessWidget {
  final String label;
  final ValueChanged<GroupEntity> onSelect;

  const GroupListPopover({
    super.key,
    required this.label,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: context.tones.expenseColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return LedgerPopoverMenu(
          title: label,
          emptyText: LocaleKeys.noGroupsFound.tr(),
          items: [
            for (final group in state.groups)
              LedgerPopoverItem(
                label: group.name,
                leading: LedgerCoin(
                  icon: LucideIcons.usersRound,
                  media: group.icon,
                  size: 26,
                ),
                onTap: () {
                  onSelect(group);
                  AppNavigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }
}
