import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/statistics/statistics_money.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_detail.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class CategoryDetailScreen extends StatelessWidget {
  final CategoryEntity category;

  const CategoryDetailScreen({super.key, required this.category});

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteCategory.tr(),
        subTitle: LocaleKeys.deleteCategoryConfirm
            .tr(namedArgs: {'name': category.name}),
        mainAction: () {
          context.read<CategoryCubit>().deleteCategory(category.clientId);
          AppNavigator.pop(context);
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
    final money = StatsMoney.of(context);
    final income = category.type == TransactionType.income;
    final accent = income ? t.incomeColor : t.expenseColor;

    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final matches = state.transactions
            .where(
              (tx) =>
                  !tx.transaction.isTransferLeg &&
                  tx.categories.any((c) => c.clientId == category.clientId),
            )
            .toList();
        final amounts = matches.map(money.convert).toList();
        final total = amounts.fold<double>(0, (a, b) => a + b);
        final biggest = amounts.fold<double>(0, (a, b) => b > a ? b : a);
        final avg = amounts.isEmpty ? 0.0 : total / amounts.length;

        return Scaffold(
          backgroundColor: t.bgPage,
          appBar: PageAppBar(
            title: category.name,
            eyebrow: income
                ? LocaleKeys.transactionIncome.tr()
                : LocaleKeys.transactionExpense.tr(),
            actions: [
              PageAppBarAction(
                icon: LucideIcons.pencil,
                onTap: () => AppNavigator.push(
                  context,
                  AddCategoryScreen(
                    category: category,
                    accentColor: accent,
                    type: category.type,
                  ),
                ),
              ),
              PageAppBarAction(
                icon: LucideIcons.trash2,
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
            children: [
              LedgerDetailHero(
                coin: LedgerCoin(
                  media: category.icon,
                  icon: LucideIcons.tag,
                  foreground: accent,
                  size: 24,
                ),
                eyebrow:
                    '${LocaleKeys.detailTotal.tr()} · ${LocaleKeys.statsEntries.plural(matches.length)}',
                figure: money.full(income ? total : -total, sign: income),
                figureColor: matches.isEmpty ? null : accent,
              ),
              if (category.description?.trim().isNotEmpty == true) ...[
                SizedBox(height: 6.lx),
                Text(
                  category.description!.trim(),
                  style: TextStyle(fontSize: 13.lx, color: t.textSecondary),
                ),
              ],
              SizedBox(height: 12.lx),
              Row(
                children: [
                  Expanded(
                    child: LedgerTotalTile(
                      label: LocaleKeys.detailAverage.tr(),
                      value: money.full(avg),
                      color: t.textPrimary,
                    ),
                  ),
                  SizedBox(width: 6.lx),
                  Expanded(
                    child: LedgerTotalTile(
                      label: LocaleKeys.detailBiggest.tr(),
                      value: money.full(biggest),
                      color: t.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.lx),
              LedgerMonthlyCard(
                buckets: ledgerMonthlyBuckets(matches, money.convert),
              ),
              SizedBox(height: 16.lx),
              LedgerRecentCard(transactions: matches),
            ],
          ),
        );
      },
    );
  }
}
