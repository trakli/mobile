import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/groups/group_detail_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class GroupListTile extends StatelessWidget {
  final GroupEntity group;
  final bool divider;

  const GroupListTile({super.key, required this.group, this.divider = true});

  void _handleEdit(BuildContext context) {
    AppNavigator.push(context, AddGroupScreen(group: group));
  }

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteGroup.tr(),
        subTitle:
            LocaleKeys.deleteGroupConfirm.tr(namedArgs: {'name': group.name}),
        mainAction: () {
          context.read<GroupCubit>().deleteGroup(group.clientId);
          AppNavigator.pop(context);
        },
        secondaryAction: () => AppNavigator.pop(context),
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final description = group.description?.trim();
    return LedgerRow(
      leading: LedgerCoin(media: group.icon, icon: LucideIcons.folder),
      title: group.name,
      subtitle: description == null || description.isEmpty ? null : description,
      divider: divider,
      onTap: () => AppNavigator.push(context, GroupDetailScreen(group: group)),
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(
          LucideIcons.ellipsisVertical,
          size: 16.lx,
          color: t.textMuted,
        ),
        onSelected: (v) {
          if (v == 'edit') _handleEdit(context);
          if (v == 'delete') _confirmDelete(context);
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'edit', child: Text(LocaleKeys.edit.tr())),
          PopupMenuItem(
            value: 'delete',
            child: Text(
              LocaleKeys.delete.tr(),
              style: TextStyle(color: t.expenseColor),
            ),
          ),
        ],
      ),
    );
  }
}
