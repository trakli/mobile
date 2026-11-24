import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/activity/activity_grouping.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_row.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/pick_group_bottom_sheet.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_currency.dart';
import 'package:trakli/presentation/utils/ledger/ledger_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

/// Every transaction grouped by day with a net total per day.
class ActivityScreen extends StatefulWidget {
  final DateTime? now;

  const ActivityScreen({super.key, this.now});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  ActivityFilter _filter = const ActivityFilter();
  bool _searching = false;

  String _dayLabel(DateTime day, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return LocaleKeys.homeToday.tr();
    if (day == today.subtract(const Duration(days: 1))) {
      return LocaleKeys.activityYesterday.tr();
    }
    final locale = Localizations.localeOf(context).toLanguageTag();
    final pattern = day.year == now.year ? 'EEE, MMM d' : 'EEE, MMM d, y';
    return DateFormat(pattern, locale).format(day);
  }

  Future<void> _pickGroup(GroupEntity? current) async {
    final cubit = context.read<TransactionCubit>();
    final picked = await showCustomBottomSheet<GroupEntity>(
      context,
      color: Theme.of(context).scaffoldBackgroundColor,
      widget: PickGroupBottomSheet(group: current),
    );
    if (picked != null) cubit.setCurrentGroup(picked);
  }

  String _subtitle(TransactionCompleteEntity t) {
    final parts = <String>[
      if (t.categories.isNotEmpty) t.categories.first.name,
      if (t.party != null && t.categories.isEmpty) t.party!.name,
      t.wallet.name,
    ];
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final now = widget.now ?? DateTime.now();
    final state = context.watch<TransactionCubit>().state;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final currency = LedgerCurrency.of(context);
    final days = groupActivityByDay(
      state.transactions.where(_filter.matches),
      currency: currency.code,
      rates: currency.rates,
    );

    Widget chip(String label, ActivityFilter f, {IconData? icon}) {
      final on = _filter.type == f.type &&
          _filter.walletClientId == f.walletClientId;
      return LedgerFilterChip(
        label: label,
        icon: icon,
        selected: on,
        onTap: () => setState(
          () => _filter = ActivityFilter(
            type: f.type,
            walletClientId: f.walletClientId,
            query: _filter.query,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: t.bgPage,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 0),
              child: LedgerScreenBar(
                leadingIcon: LucideIcons.chevronLeft,
                title: LocaleKeys.activityTitle.tr(),
                actions: [
                  LedgerIconButton(
                    icon: _searching ? LucideIcons.x : LucideIcons.search,
                    tooltip: LocaleKeys.search.tr(),
                    onTap: () => setState(() {
                      _searching = !_searching;
                      if (!_searching) {
                        _filter = ActivityFilter(
                          type: _filter.type,
                          walletClientId: _filter.walletClientId,
                        );
                      }
                    }),
                  ),
                  LedgerIconButton(
                    icon: LucideIcons.slidersHorizontal,
                    tooltip: LocaleKeys.activityMoreFilters.tr(),
                    onTap: () =>
                        AppNavigator.push(context, const HistoryScreen()),
                  ),
                ],
              ),
            ),
            if (_searching)
              Padding(
                padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 0),
                child: TextField(
                  autofocus: true,
                  onChanged: (q) => setState(
                    () => _filter = ActivityFilter(
                      type: _filter.type,
                      walletClientId: _filter.walletClientId,
                      query: q,
                    ),
                  ),
                  style: TextStyle(fontSize: 13.lx),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: LocaleKeys.activitySearchHint.tr(),
                    prefixIcon: Icon(LucideIcons.search, size: 16.lx),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 4.lx),
              child: LedgerChipRow(
                children: [
                  chip(LocaleKeys.activityAll.tr(), const ActivityFilter()),
                  chip(
                    LocaleKeys.activitySpending.tr(),
                    const ActivityFilter(type: ActivityFilterType.spending),
                  ),
                  chip(
                    LocaleKeys.activityIncome.tr(),
                    const ActivityFilter(type: ActivityFilterType.income),
                  ),
                  for (final w in wallets)
                    chip(
                      w.name,
                      ActivityFilter(
                        type: ActivityFilterType.wallet,
                        walletClientId: w.clientId,
                      ),
                    ),
                  chip(
                    LocaleKeys.activityPeople.tr(),
                    const ActivityFilter(type: ActivityFilterType.people),
                  ),
                  LedgerFilterChip(
                    label: state.selectedGroup?.name ?? LocaleKeys.group.tr(),
                    leading: LedgerMediaIcon(
                      media: state.selectedGroup?.icon,
                      fallback: LucideIcons.folder,
                      size: 13,
                    ),
                    onTap: () => _pickGroup(state.selectedGroup),
                  ),
                ],
              ),
            ),
            Expanded(
              child: days.isEmpty
                  ? Center(
                      child: Text(
                        LocaleKeys.activityEmpty.tr(),
                        style: TextStyle(fontSize: 13.lx, color: t.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 24.lx),
                      itemCount: days.length,
                      itemBuilder: (context, i) {
                        final day = days[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.lx),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.lx),
                                child: LedgerH6(
                                  _dayLabel(day.day, now),
                                  trailing: Text(
                                    LedgerMoney.format(
                                      day.net,
                                      currency.code,
                                      sign: true,
                                    ),
                                    style: LedgerText.money(
                                      size: 11.lx,
                                      color: t.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                              for (final tx in day.transactions)
                                LedgerTransactionRow(
                                  transaction: tx,
                                  subtitle: _subtitle(tx),
                                  verticalPadding: 8,
                                  divider: tx != day.transactions.last,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
