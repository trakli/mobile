import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
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

class GroupDetailScreen extends StatelessWidget {
  final GroupEntity group;

  const GroupDetailScreen({super.key, required this.group});

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

    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final matches = state.transactions
            .where((tx) => tx.group?.clientId == group.clientId)
            .toList();
        double received = 0;
        double spent = 0;
        for (final tx in matches) {
          if (tx.transaction.isTransferLeg) continue;
          if (tx.transaction.type == TransactionType.income) {
            received += money.convert(tx);
          } else {
            spent += money.convert(tx);
          }
        }
        final net = received - spent;

        return Scaffold(
          backgroundColor: t.bgPage,
          appBar: PageAppBar(
            title: group.name,
            eyebrow: LocaleKeys.groupsMyGroups.tr(),
            actions: [
              PageAppBarAction(
                icon: LucideIcons.pencil,
                onTap: () =>
                    AppNavigator.push(context, AddGroupScreen(group: group)),
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
                  media: group.icon,
                  icon: LucideIcons.folder,
                  size: 24,
                ),
                eyebrow:
                    '${LocaleKeys.detailNetFlow.tr()} · ${LocaleKeys.statsEntries.plural(matches.length)}',
                figure: money.full(net, sign: true),
                figureColor:
                    net > 0 ? t.incomeColor : (net < 0 ? t.expenseColor : null),
              ),
              if (group.description?.trim().isNotEmpty == true) ...[
                SizedBox(height: 6.lx),
                Text(
                  group.description!.trim(),
                  style: TextStyle(fontSize: 13.lx, color: t.textSecondary),
                ),
              ],
              SizedBox(height: 12.lx),
              Row(
                children: [
                  Expanded(
                    child: LedgerTotalTile(
                      label: LocaleKeys.statsFlowIn.tr(),
                      value: money.full(received),
                      color: t.incomeColor,
                    ),
                  ),
                  SizedBox(width: 6.lx),
                  Expanded(
                    child: LedgerTotalTile(
                      label: LocaleKeys.statsFlowOut.tr(),
                      value: money.full(spent),
                      color: t.expenseColor,
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
