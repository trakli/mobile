import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/parties/widgets/party_list_tile.dart';
import 'package:trakli/presentation/statistics/statistics_money.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  String _query = '';
  _PartyFilter _filter = _PartyFilter.all;

  Map<String, _PartyTotals> _computeStats(
    List<PartyEntity> parties,
    TransactionState transactionState,
    StatsMoney money,
  ) {
    final received = <String, double>{};
    final spent = <String, double>{};
    for (final txn in transactionState.transactions) {
      final id = txn.party?.clientId;
      if (id == null || txn.transaction.isTransferLeg) continue;
      final amount = money.convert(txn);
      if (txn.transaction.type == TransactionType.income) {
        received[id] = (received[id] ?? 0) + amount;
      } else {
        spent[id] = (spent[id] ?? 0) + amount;
      }
    }
    return {
      for (final p in parties)
        p.clientId: _PartyTotals(
          received: received[p.clientId] ?? 0,
          spent: spent[p.clientId] ?? 0,
        ),
    };
  }

  void _add() => AppNavigator.push(context, const AddPartyScreen());

  String _label(_PartyFilter f) => switch (f) {
        _PartyFilter.all => LocaleKeys.walletsFilterAll.tr(),
        _PartyFilter.earner => LocaleKeys.partiesFilterEarners.tr(),
        _PartyFilter.spender => LocaleKeys.partiesFilterSpenders.tr(),
        _PartyFilter.idle => LocaleKeys.walletsFilterIdle.tr(),
      };

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final money = StatsMoney.of(context);
    return BlocBuilder<PartyCubit, PartyState>(
      builder: (context, partyState) {
        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, transactionState) {
            final parties = partyState.parties;
            final stats = _computeStats(parties, transactionState, money);
            final filtered = _applyFilters(parties, stats);
            final totals = _aggregateTotals(parties, stats);
            final net = totals.received - totals.spent;
            final counts = {
              _PartyFilter.all: parties.length,
              _PartyFilter.earner: totals.earnerCount,
              _PartyFilter.spender: totals.spenderCount,
              _PartyFilter.idle: totals.idleCount,
            };

            return Scaffold(
              backgroundColor: t.bgPage,
              appBar: PageAppBar(
                title: LocaleKeys.parties.tr(),
                onSearchChanged:
                    parties.isEmpty ? null : (v) => setState(() => _query = v),
                searchHint: LocaleKeys.partiesSearchHint.tr(),
                actions: [
                  PageAppBarAction(
                    icon: LucideIcons.plus,
                    onTap: _add,
                    primary: true,
                  ),
                ],
              ),
              body: partyState.isLoading && parties.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : parties.isEmpty
                      ? InfoInterface(action: _add, data: emptyPartyData)
                      : ListView(
                          padding:
                              EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
                          children: [
                            Text(
                              LocaleKeys.partiesNet.tr(),
                              style: TextStyle(
                                fontSize: 12.5.lx,
                                color: t.textMuted,
                              ),
                            ),
                            SizedBox(height: 2.lx),
                            LedgerBigNumber(
                              money.full(net, sign: true),
                              color: net < 0
                                  ? t.expenseColor
                                  : (net > 0 ? t.incomeColor : null),
                            ),
                            SizedBox(height: 10.lx),
                            Row(
                              children: [
                                Expanded(
                                  child: LedgerTotalTile(
                                    label: LocaleKeys.statsFlowIn.tr(),
                                    value: money.full(totals.received),
                                    color: t.incomeColor,
                                  ),
                                ),
                                SizedBox(width: 6.lx),
                                Expanded(
                                  child: LedgerTotalTile(
                                    label: LocaleKeys.statsFlowOut.tr(),
                                    value: money.full(totals.spent),
                                    color: t.expenseColor,
                                  ),
                                ),
                                SizedBox(width: 6.lx),
                                Expanded(
                                  child: LedgerTotalTile(
                                    label: LocaleKeys.active.tr(),
                                    value:
                                        '${totals.activeCount} / ${parties.length}',
                                    color: t.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.lx),
                            LedgerChipRow(
                              children: [
                                for (final f in _PartyFilter.values)
                                  LedgerFilterChip(
                                    label: '${_label(f)} · ${counts[f] ?? 0}',
                                    selected: f == _filter,
                                    onTap: () => setState(() => _filter = f),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10.lx),
                            if (filtered.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.lx),
                                child: Text(
                                  _query.trim().isEmpty
                                      ? LocaleKeys.listNoMatchFilter.tr()
                                      : LocaleKeys.walletsNoMatchQuery
                                          .tr(args: [_query.trim()]),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.lx,
                                    color: t.textMuted,
                                  ),
                                ),
                              )
                            else
                              LedgerCard(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12.lx),
                                child: Column(
                                  children: [
                                    for (final p in filtered)
                                      PartyListTile(
                                        party: p,
                                        receivedAmount:
                                            stats[p.clientId]?.received ?? 0,
                                        spentAmount:
                                            stats[p.clientId]?.spent ?? 0,
                                        currency: money.currency,
                                        divider: p != filtered.last,
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
            );
          },
        );
      },
    );
  }

  List<PartyEntity> _applyFilters(
    List<PartyEntity> parties,
    Map<String, _PartyTotals> stats,
  ) {
    final q = _query.trim().toLowerCase();
    Iterable<PartyEntity> scope = parties;
    switch (_filter) {
      case _PartyFilter.all:
        break;
      case _PartyFilter.earner:
        scope = scope.where((p) => (stats[p.clientId]?.received ?? 0) > 0);
        break;
      case _PartyFilter.spender:
        scope = scope.where((p) => (stats[p.clientId]?.spent ?? 0) > 0);
        break;
      case _PartyFilter.idle:
        scope = scope.where((p) =>
            (stats[p.clientId]?.received ?? 0) == 0 &&
            (stats[p.clientId]?.spent ?? 0) == 0);
        break;
    }
    if (q.isNotEmpty) {
      scope = scope.where((p) {
        final hay = '${p.name} ${p.description ?? ''} '
                '${p.type?.customName ?? ''}'
            .toLowerCase();
        return hay.contains(q);
      });
    }
    final list = scope.toList()
      ..sort((a, b) {
        final na = (stats[a.clientId]?.net ?? 0).abs();
        final nb = (stats[b.clientId]?.net ?? 0).abs();
        final cmp = nb.compareTo(na);
        if (cmp != 0) return cmp;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return list;
  }

  _AggregateTotals _aggregateTotals(
    List<PartyEntity> parties,
    Map<String, _PartyTotals> stats,
  ) {
    double received = 0;
    double spent = 0;
    int earnerCount = 0;
    int spenderCount = 0;
    int idleCount = 0;
    int activeCount = 0;
    for (final p in parties) {
      final s = stats[p.clientId];
      final r = s?.received ?? 0;
      final sp = s?.spent ?? 0;
      received += r;
      spent += sp;
      if (r > 0) earnerCount++;
      if (sp > 0) spenderCount++;
      if (r == 0 && sp == 0) {
        idleCount++;
      } else {
        activeCount++;
      }
    }
    return _AggregateTotals(
      received: received,
      spent: spent,
      earnerCount: earnerCount,
      spenderCount: spenderCount,
      idleCount: idleCount,
      activeCount: activeCount,
    );
  }
}

class _PartyTotals {
  final double received;
  final double spent;
  const _PartyTotals({required this.received, required this.spent});
  double get net => received - spent;
}

class _AggregateTotals {
  final double received;
  final double spent;
  final int earnerCount;
  final int spenderCount;
  final int idleCount;
  final int activeCount;
  const _AggregateTotals({
    required this.received,
    required this.spent,
    required this.earnerCount,
    required this.spenderCount,
    required this.idleCount,
    required this.activeCount,
  });
}

enum _PartyFilter { all, earner, spender, idle }
