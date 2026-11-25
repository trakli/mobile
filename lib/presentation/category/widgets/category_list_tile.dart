import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class CategoryListTile extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool divider;

  const CategoryListTile({
    super.key,
    required this.category,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.divider = true,
  });

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteCategory.tr(),
        subTitle: LocaleKeys.deleteCategoryConfirm
            .tr(namedArgs: {'name': category.name}),
        mainAction: () {
          Navigator.pop(context);
          onDelete?.call();
        },
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final income = category.type == TransactionType.income;
    final description = category.description?.trim();
    return LedgerRow(
      leading: LedgerCoin(
        media: category.icon,
        icon: LucideIcons.tag,
        foreground: income ? t.incomeColor : t.expenseColor,
      ),
      title: category.name,
      subtitle: description == null || description.isEmpty
          ? (income
              ? LocaleKeys.transactionIncome.tr()
              : LocaleKeys.transactionExpense.tr())
          : description,
      divider: divider,
      onTap: onTap ?? onEdit,
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(
          LucideIcons.ellipsisVertical,
          size: 16.lx,
          color: t.textMuted,
        ),
        onSelected: (v) {
          if (v == 'edit') onEdit?.call();
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
