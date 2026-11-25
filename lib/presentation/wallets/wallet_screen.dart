import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/wallets/wallet_detail_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _query = '';
  _WalletFilter _filter = _WalletFilter.all;

  void _add() {
    AppNavigator.push(context, const AddWalletScreen());
  }

  _Totals _walletTotals(
    WalletEntity wallet,
    List<TransactionCompleteEntity> txns,
  ) {
    double income = 0;
    double expense = 0;
    for (final t in txns) {
      if (t.transaction.walletClientId != wallet.clientId) continue;
      final amt = t.transaction.amount;
      if (t.transaction.type == TransactionType.income) {
        income += amt;
      } else {
        expense += amt;
      }
    }
    return _Totals(income: income, expense: expense);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final tones = context.tones;
        final transactions =
            context.watch<TransactionCubit>().state.transactions;
        final defaultWalletId = context
            .watch<ConfigCubit>()
            .state
            .getConfigByKey(ConfigConstants.defaultWallet)
            ?.value as String?;
        final defaultCurrencyCode =
            context.watch<CurrencyCubit>().state.currency?.code;

        final perWallet = <String, _Totals>{
          for (final w in state.wallets)
            w.clientId: _walletTotals(w, transactions),
        };

        // Aggregate is shown only in the default currency to keep the
        // hero number meaningful (no cross-currency mixing).
        final scope = defaultCurrencyCode == null
            ? state.wallets
            : state.wallets
                .where((w) => w.currencyCode == defaultCurrencyCode)
                .toList();
        double aggIncome = 0;
        double aggExpense = 0;
        for (final w in scope) {
          final t = perWallet[w.clientId]!;
          aggIncome += t.income;
          aggExpense += t.expense;
        }

        final filtered = _applyFilters(
          state.wallets,
          perWallet,
          defaultWalletId,
        );

        final isEmpty = state.wallets.isEmpty;

        final money = defaultCurrencyCode ?? 'USD';
        final balance = aggIncome - aggExpense;
        final counts = _filterCounts(
          state.wallets,
          perWallet,
          defaultCurrencyCode,
        );

        return Scaffold(
          backgroundColor: tones.bgPage,
          appBar: PageAppBar(
            title: LocaleKeys.wallets.tr(),
            showBack: false,
            onSearchChanged: isEmpty ? null : (v) => setState(() => _query = v),
            searchHint: LocaleKeys.walletsSearchHint.tr(),
            actions: [
              PageAppBarAction(
                icon: LucideIcons.plus,
                onTap: _add,
                primary: true,
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : isEmpty
                  ? InfoInterface(action: _add, data: emptyWalletData)
                  : ListView(
                      padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 120.lx),
                      children: [
                        Text(
                          LocaleKeys.walletsBalanceIn.tr(args: [money]),
                          style: TextStyle(
                            fontSize: 12.5.lx,
                            color: tones.textMuted,
                          ),
                        ),
                        LedgerBigNumber(
                          LedgerMoney.format(balance, money),
                          color: balance < 0 ? tones.expenseColor : null,
                        ),
                        SizedBox(height: 10.lx),
                        Row(
                          children: [
                            Expanded(
                              child: LedgerTotalTile(
                                label: LocaleKeys.statsFlowIn.tr(),
                                value: LedgerMoney.format(aggIncome, money),
                                color: tones.incomeColor,
                              ),
                            ),
                            SizedBox(width: 6.lx),
                            Expanded(
                              child: LedgerTotalTile(
                                label: LocaleKeys.statsFlowOut.tr(),
                                value: LedgerMoney.format(aggExpense, money),
                                color: tones.expenseColor,
                              ),
                            ),
                            SizedBox(width: 6.lx),
                            Expanded(
                              child: LedgerTotalTile(
                                label: LocaleKeys.active.tr(),
                                value:
                                    '${counts[_WalletFilter.active] ?? 0} / ${state.wallets.length}',
                                color: tones.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.lx),
                        LedgerChipRow(
                          children: [
                            for (final f in _WalletFilter.values)
                              LedgerFilterChip(
                                label: '${_label(f)} · ${counts[f] ?? 0}',
                                selected: f == _filter,
                                onTap: () => setState(() => _filter = f),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.lx),
                        if (filtered.isEmpty)
                          _NoMatches(query: _query)
                        else
                          LedgerCard(
                            padding: EdgeInsets.symmetric(horizontal: 12.lx),
                            child: Column(
                              children: [
                                for (final w in filtered)
                                  _WalletRow(
                                    wallet: w,
                                    totals: perWallet[w.clientId]!,
                                    isDefault: w.clientId == defaultWalletId,
                                    divider: w != filtered.last,
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
        );
      },
    );
  }

  String _label(_WalletFilter f) => switch (f) {
        _WalletFilter.all => LocaleKeys.walletsFilterAll.tr(),
        _WalletFilter.active => LocaleKeys.active.tr(),
        _WalletFilter.idle => LocaleKeys.walletsFilterIdle.tr(),
        _WalletFilter.defaultCurrency =>
          LocaleKeys.walletsFilterDefaultCurrency.tr(),
      };

  Map<_WalletFilter, int> _filterCounts(
    List<WalletEntity> wallets,
    Map<String, _Totals> stats,
    String? defaultCurrencyCode,
  ) {
    int defaultCurrencyCount = 0;
    int activeCount = 0;
    int idleCount = 0;
    for (final w in wallets) {
      final t = stats[w.clientId]!;
      if (defaultCurrencyCode != null &&
          w.currencyCode == defaultCurrencyCode) {
        defaultCurrencyCount++;
      }
      if (t.income > 0 || t.expense > 0) {
        activeCount++;
      } else {
        idleCount++;
      }
    }
    return {
      _WalletFilter.all: wallets.length,
      _WalletFilter.active: activeCount,
      _WalletFilter.idle: idleCount,
      _WalletFilter.defaultCurrency: defaultCurrencyCount,
    };
  }

  List<WalletEntity> _applyFilters(
    List<WalletEntity> wallets,
    Map<String, _Totals> stats,
    String? defaultWalletId,
  ) {
    final q = _query.trim().toLowerCase();
    Iterable<WalletEntity> scope = wallets;
    switch (_filter) {
      case _WalletFilter.all:
        break;
      case _WalletFilter.active:
        scope = scope.where((w) {
          final t = stats[w.clientId]!;
          return t.income > 0 || t.expense > 0;
        });
        break;
      case _WalletFilter.idle:
        scope = scope.where((w) {
          final t = stats[w.clientId]!;
          return t.income == 0 && t.expense == 0;
        });
        break;
      case _WalletFilter.defaultCurrency:
        final defaultCurrencyCode =
            context.read<CurrencyCubit>().state.currency?.code;
        if (defaultCurrencyCode != null) {
          scope = scope.where((w) => w.currencyCode == defaultCurrencyCode);
        }
        break;
    }
    if (q.isNotEmpty) {
      scope = scope.where((w) {
        final hay =
            '${w.name} ${w.description ?? ''} ${w.currencyCode}'.toLowerCase();
        return hay.contains(q);
      });
    }
    final list = scope.toList()
      ..sort((a, b) {
        // Default wallet first; then by absolute balance descending.
        if (a.clientId == defaultWalletId) return -1;
        if (b.clientId == defaultWalletId) return 1;
        final ta = stats[a.clientId]!;
        final tb = stats[b.clientId]!;
        final ba = (ta.income - ta.expense).abs();
        final bb = (tb.income - tb.expense).abs();
        final cmp = bb.compareTo(ba);
        if (cmp != 0) return cmp;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return list;
  }
}

class _Totals {
  final double income;
  final double expense;
  const _Totals({required this.income, required this.expense});
}

enum _WalletFilter { all, active, idle, defaultCurrency }

class _WalletRow extends StatelessWidget {
  final WalletEntity wallet;
  final _Totals totals;
  final bool isDefault;
  final bool divider;

  const _WalletRow({
    required this.wallet,
    required this.totals,
    required this.isDefault,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final balance = totals.income - totals.expense;
    final code = wallet.currencyCode;
    return LedgerRow(
      leading: LedgerCoin(media: wallet.icon, icon: LucideIcons.wallet),
      title: wallet.name,
      subtitleWidget: Row(
        children: [
          if (isDefault) ...[
            LedgerChip(LocaleKeys.walletsDefault.tr(),
                tone: LedgerChipTone.good),
            SizedBox(width: 6.lx),
          ],
          Flexible(
            child: Text(
              code,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.lx, color: t.textMuted),
            ),
          ),
        ],
      ),
      trailing: LedgerAmount(
        LedgerMoney.format(balance, code),
        size: 13.5,
        weight: FontWeight.w600,
        color: balance < 0 ? t.expenseColor : t.textPrimary,
      ),
      divider: divider,
      onTap: () => AppNavigator.push(
        context,
        WalletDetailScreen(wallet: wallet),
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  final String query;
  const _NoMatches({required this.query});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.lx),
      child: Column(
        children: [
          Icon(LucideIcons.searchX, size: 28.lx, color: t.textMuted),
          SizedBox(height: 10.lx),
          Text(
            query.isEmpty
                ? LocaleKeys.walletsNoMatchFilter.tr()
                : LocaleKeys.walletsNoMatchQuery.tr(args: [query]),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.lx, color: t.textSecondary),
          ),
        ],
      ),
    );
  }
}
