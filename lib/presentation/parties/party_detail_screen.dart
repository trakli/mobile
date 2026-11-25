import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/parties/party_debt.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/statistics/statistics_money.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/dialogs/pop_up_dialog.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_detail.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

enum _PartyAction { edit, delete }

/// Detail screen for a single party: what is owed either way, quick payback
/// and reminder actions, the loan history, then totals, monthly activity and
/// recent transactions. Reads from the existing cubits only.
class PartyDetailScreen extends StatelessWidget {
  final PartyEntity party;

  const PartyDetailScreen({super.key, required this.party});

  bool _isMine(TransactionCompleteEntity t) =>
      t.party?.clientId == party.clientId ||
      t.transaction.partyClientId == party.clientId;

  ({double received, double spent, double net}) _totals(
    List<TransactionCompleteEntity> txns,
    double Function(TransactionCompleteEntity) convert,
  ) {
    double received = 0;
    double spent = 0;
    for (final t in txns) {
      if (!_isMine(t) || t.transaction.isTransferLeg) continue;
      final amt = convert(t);
      if (t.transaction.type == TransactionType.income) {
        received += amt;
      } else {
        spent += amt;
      }
    }
    return (received: received, spent: spent, net: received - spent);
  }

  String get _shortName {
    final isPerson = party.type == null || party.type == PartyType.individual;
    if (!isPerson) return party.name;
    final first = party.name.trim().split(RegExp(r'\s+')).first;
    return first.isEmpty ? party.name : first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final tones = context.tones;
        final rates = context.watch<ExchangeRateCubit>().state.entity;
        final reminders = context.watch<ReminderCubit>().state.reminders;
        final debt = computePartyDebt(
          state.transactions,
          party.clientId,
          rates: rates,
        );
        final mine = state.transactions.where(_isMine).toList();
        final currency = rates?.baseCode ??
            (mine.isNotEmpty ? mine.first.wallet.currencyCode : 'EUR');
        final money = StatsMoney.of(context);
        final totals = _totals(state.transactions, money.convert);

        return Scaffold(
          backgroundColor: tones.bgPage,
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 24.lx),
              children: [
                LedgerScreenBar(
                  leadingIcon: LucideIcons.chevronLeft,
                  title: party.name,
                  actions: [
                    PopupMenuButton<_PartyAction>(
                      onSelected: (a) => switch (a) {
                        _PartyAction.edit => AppNavigator.push(
                            context,
                            AddPartyScreen(party: party),
                          ),
                        _PartyAction.delete => _confirmDelete(context),
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: _PartyAction.edit,
                          child: _MenuLabel(
                            icon: LucideIcons.pencil,
                            text: LocaleKeys.edit.tr(),
                          ),
                        ),
                        PopupMenuItem(
                          value: _PartyAction.delete,
                          child: _MenuLabel(
                            icon: LucideIcons.trash2,
                            text: LocaleKeys.delete.tr(),
                            color: tones.expenseColor,
                          ),
                        ),
                      ],
                      child: const LedgerIconButton(icon: LucideIcons.ellipsis),
                    ),
                  ],
                ),
                SizedBox(height: 12.lx),
                _DebtCard(
                  debt: debt,
                  name: _shortName,
                  currency: currency,
                ),
                SizedBox(height: 12.lx),
                Row(
                  children: [
                    Expanded(
                      child: LedgerButton(
                        label: LocaleKeys.partyPayback.tr(),
                        icon: LucideIcons.handCoins,
                        onPressed: () => _payback(context, debt, mine),
                      ),
                    ),
                    SizedBox(width: 8.lx),
                    Expanded(
                      child: LedgerButton(
                        label: LocaleKeys.partyRemind.tr(),
                        icon: LucideIcons.bell,
                        style: LedgerButtonStyle.outline,
                        onPressed: debt.direction == PartyDebtDirection.settled
                            ? null
                            : () => _remind(context, debt, currency),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.lx),
                _HistoryCard(
                  party: party,
                  shortName: _shortName,
                  transactions: mine,
                  reminders: reminders,
                ),
                if ((party.type != null &&
                        party.type != PartyType.individual) ||
                    (party.description?.isNotEmpty ?? false)) ...[
                  SizedBox(height: 12.lx),
                  _AboutRow(party: party),
                ],
                SizedBox(height: 20.lx),
                _TotalsRow(totals: totals, currency: money.currency),
                SizedBox(height: 12.lx),
                LedgerMonthlyCard(
                  buckets: ledgerMonthlyBuckets(mine, money.convert),
                ),
                SizedBox(height: 20.lx),
                LedgerRecentCard(
                  transactions: mine,
                  emptyText: LocaleKeys.partyNoTransactions.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _payback(
    BuildContext context,
    PartyDebtBalance debt,
    List<TransactionCompleteEntity> mine,
  ) {
    final intents = mine.map((t) => t.transaction.intent).toSet();
    final youOwe = debt.direction == PartyDebtDirection.youOweThem;
    final TransactionIntent intent;
    if (youOwe) {
      intent = intents.contains(TransactionIntent.loanReceived) &&
              !intents.contains(TransactionIntent.debtOwed)
          ? TransactionIntent.loanRepayment
          : TransactionIntent.debtSettled;
    } else {
      intent = intents.contains(TransactionIntent.loanRepayment) &&
              !intents.contains(TransactionIntent.debtSettled)
          ? TransactionIntent.loanReceived
          : TransactionIntent.debtOwed;
    }
    AppNavigator.push(
      context,
      AddTransactionScreen(
        transactionType:
            youOwe ? TransactionType.expense : TransactionType.income,
        initialParty: party,
        initialIntent: intent,
        initialAmount: debt.direction == PartyDebtDirection.settled
            ? null
            : double.parse(debt.outstanding.toStringAsFixed(2)),
      ),
    );
  }

  Future<void> _remind(
    BuildContext context,
    PartyDebtBalance debt,
    String currency,
  ) async {
    final cubit = context.read<ReminderCubit>();
    final amount = LedgerMoney.format(debt.outstanding, currency);
    final title = debt.direction == PartyDebtDirection.theyOweYou
        ? LocaleKeys.partyReminderPaysBack
            .tr(namedArgs: {'name': _shortName, 'amount': amount})
        : LocaleKeys.partyReminderYouPayBack
            .tr(namedArgs: {'name': _shortName, 'amount': amount});
    final now = DateTime.now();
    final when = DateTime(now.year, now.month, now.day + 1, 9);
    await cubit.createReminder(
      title: title,
      description: party.name,
      type: ReminderType.custom,
      triggerAt: when,
    );
    if (cubit.state.failure.hasError) {
      showSnackBar(message: LocaleKeys.partyReminderFailed.tr());
    } else {
      showSnackBar(
        message: LocaleKeys.partyReminderSet
            .tr(namedArgs: {'date': DateFormat.MMMd().format(when)}),
        isSuccess: true,
      );
    }
  }

  void _confirmDelete(BuildContext context) {
    showCustomDialog(
      widget: PopUpDialog(
        dialogType: DialogType.negative,
        title: LocaleKeys.deleteParty.tr(),
        subTitle:
            LocaleKeys.deletePartyConfirm.tr(namedArgs: {'name': party.name}),
        mainAction: () {
          context.read<PartyCubit>().deleteParty(party.clientId);
          AppNavigator.pop(context);
          AppNavigator.pop(context);
        },
        secondaryAction: () => AppNavigator.pop(context),
        mainActionText: LocaleKeys.delete.tr(),
        secondaryActionText: LocaleKeys.cancel.tr(),
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _MenuLabel({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.tones.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 16.lx, color: c),
        SizedBox(width: 10.lx),
        Text(text, style: TextStyle(fontSize: 13.5.lx, color: c)),
      ],
    );
  }
}

class _DebtCard extends StatelessWidget {
  final PartyDebtBalance debt;
  final String name;
  final String currency;

  const _DebtCard({
    required this.debt,
    required this.name,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final label = !debt.hasHistory
        ? LocaleKeys.partyNothingOwed.tr(namedArgs: {'name': name})
        : switch (debt.direction) {
            PartyDebtDirection.theyOweYou =>
              LocaleKeys.partyOwesYou.tr(namedArgs: {'name': name}),
            PartyDebtDirection.youOweThem =>
              LocaleKeys.partyYouOwe.tr(namedArgs: {'name': name}),
            PartyDebtDirection.settled => LocaleKeys.partySettled.tr(),
          };
    final color = switch (debt.direction) {
      PartyDebtDirection.theyOweYou => t.incomeColor,
      PartyDebtDirection.youOweThem => t.expenseColor,
      PartyDebtDirection.settled => t.textPrimary,
    };
    return LedgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: TextStyle(fontSize: 12.lx, color: t.textMuted)),
          SizedBox(height: 8.lx),
          LedgerBigNumber(
            LedgerMoney.format(debt.outstanding, currency),
            color: color,
          ),
          if (debt.hasHistory) ...[
            SizedBox(height: 8.lx),
            LedgerBar(value: debt.progress, height: 8),
            SizedBox(height: 8.lx),
            Text(
              LocaleKeys.partyPaidBackOf.tr(namedArgs: {
                'repaid': LedgerMoney.format(debt.repaid, currency),
                'total': LedgerMoney.format(debt.total, currency),
              }),
              style: TextStyle(fontSize: 11.5.lx, color: t.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _HistoryEvent {
  final DateTime date;
  final LedgerTimelineEntry entry;
  const _HistoryEvent(this.date, this.entry);
}

class _HistoryCard extends StatelessWidget {
  final PartyEntity party;
  final String shortName;
  final List<TransactionCompleteEntity> transactions;
  final List<ReminderEntity> reminders;

  const _HistoryCard({
    required this.party,
    required this.shortName,
    required this.transactions,
    required this.reminders,
  });

  bool _isOutflow(TransactionIntent i) =>
      i == TransactionIntent.loanRepayment ||
      i == TransactionIntent.debtSettled;

  List<_HistoryEvent> _events() {
    final loans = transactions
        .where((t) => isLoanOrDebtIntent(t.transaction.intent))
        .toList()
      ..sort(
          (a, b) => a.transaction.datetime.compareTo(b.transaction.datetime));
    final youLent = loans.isEmpty || _isOutflow(loans.first.transaction.intent);
    final dates = DateFormat.MMMd();
    final events = <_HistoryEvent>[
      for (final t in loans)
        _HistoryEvent(
          t.transaction.datetime,
          LedgerTimelineEntry(
            _label(t, youLent),
            dates.format(t.transaction.datetime),
            LedgerTimelineTone.good,
          ),
        ),
    ];
    final name = party.name.toLowerCase();
    for (final r in reminders) {
      if (r.status == ReminderStatus.completed ||
          r.status == ReminderStatus.cancelled) {
        continue;
      }
      final mentions = r.title.toLowerCase().contains(name) ||
          r.title.toLowerCase().contains(shortName.toLowerCase()) ||
          (r.description?.toLowerCase() == name);
      if (!mentions) continue;
      final when = r.nextTriggerAt ?? r.triggerAt ?? r.dueAt ?? r.createdAt;
      events.add(_HistoryEvent(
        when,
        LedgerTimelineEntry(
          LocaleKeys.partyHistoryReminder.tr(namedArgs: {'title': r.title}),
          dates.format(when),
          LedgerTimelineTone.warm,
        ),
      ));
    }
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  String _label(TransactionCompleteEntity t, bool youLent) {
    final amount =
        LedgerMoney.format(t.transaction.amount, t.wallet.currencyCode);
    final wallet = t.wallet.name;
    final out = _isOutflow(t.transaction.intent);
    if (youLent) {
      return out
          ? LocaleKeys.partyHistoryLent
              .tr(namedArgs: {'amount': amount, 'wallet': wallet})
          : LocaleKeys.partyHistoryPaidBack.tr(namedArgs: {'amount': amount});
    }
    return out
        ? LocaleKeys.partyHistoryRepaid.tr(namedArgs: {'amount': amount})
        : LocaleKeys.partyHistoryBorrowed
            .tr(namedArgs: {'amount': amount, 'wallet': wallet});
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final events = _events();
    return LedgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LedgerH6(LocaleKeys.partyHistory.tr()),
          SizedBox(height: 6.lx),
          if (events.isEmpty)
            Text(
              LocaleKeys.partyNoHistory.tr(namedArgs: {'name': shortName}),
              style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
            )
          else
            LedgerTimeline(entries: [for (final e in events) e.entry]),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final PartyEntity party;

  const _AboutRow({required this.party});

  IconData _iconForType(PartyType? type) {
    return switch (type) {
      PartyType.business => LucideIcons.store,
      PartyType.organization => LucideIcons.building2,
      PartyType.partnership => LucideIcons.handshake,
      PartyType.nonProfit => LucideIcons.heartHandshake,
      PartyType.governmentAgency => LucideIcons.landmark,
      PartyType.educationalInstitution => LucideIcons.graduationCap,
      PartyType.healthcareProvider => LucideIcons.stethoscope,
      _ => LucideIcons.userRound,
    };
  }

  @override
  Widget build(BuildContext context) {
    final details = [
      if (party.type != null) party.type!.customName,
      if (party.description?.isNotEmpty ?? false) party.description!,
    ];
    return LedgerRow(
      leading: LedgerCoin(icon: _iconForType(party.type), media: party.icon),
      title: details.first,
      subtitle: details.length > 1 ? details[1] : null,
      divider: false,
    );
  }
}

class _TotalsRow extends StatelessWidget {
  final ({double received, double spent, double net}) totals;
  final String currency;

  const _TotalsRow({required this.totals, required this.currency});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    Widget cell(String label, double value, Color color, {bool sign = false}) {
      return Expanded(
        child: LedgerCard(
          padding: EdgeInsets.all(8.lx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 11.lx, color: t.textMuted)),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: LedgerAmount(
                  LedgerMoney.format(value, currency, sign: sign),
                  size: 14,
                  weight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        cell(LocaleKeys.partyReceived.tr(), totals.received, t.incomeColor),
        SizedBox(width: 6.lx),
        cell(LocaleKeys.partySpent.tr(), totals.spent, t.textPrimary),
        SizedBox(width: 6.lx),
        cell(
          LocaleKeys.partyNet.tr(),
          totals.net,
          totals.net >= 0 ? t.incomeColor : t.expenseColor,
          sign: true,
        ),
      ],
    );
  }
}
