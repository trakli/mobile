import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';

String spaceRoleLabel(String role) => switch (role) {
      'owner' => LocaleKeys.spaceRoleOwner.tr(),
      'admin' => LocaleKeys.spaceRoleAdmin.tr(),
      _ => LocaleKeys.spaceRoleMember.tr(),
    };

String spaceRoleOf(SpaceRole role) => spaceRoleLabel(role.name);

String spacePeopleLabel(int count) => count == 1
    ? LocaleKeys.spaceOnePerson.tr()
    : LocaleKeys.spacePeopleCount.tr(namedArgs: {'count': '$count'});

String spaceContributorName(String contributor) =>
    contributor.trim().isEmpty ? LocaleKeys.spaceSomeone.tr() : contributor;

/// The label a member sees for a space transaction: its first space category,
/// falling back to the wallet it was recorded in.
String? spaceTransactionLabel(
  SpaceTransactionEntity tx,
  SpaceOverviewEntity? overview,
) {
  for (final id in tx.categoryIds) {
    final c = overview?.categoryById(id);
    if (c != null) return c.name;
  }
  return tx.walletName;
}

String spaceTransactionTitle(
  SpaceTransactionEntity tx,
  SpaceOverviewEntity? overview,
) {
  final d = tx.description?.trim();
  if (d != null && d.isNotEmpty) return d;
  return spaceTransactionLabel(tx, overview) ?? '';
}

String spaceSignedAmount(SpaceTransactionEntity tx) => LedgerMoney.format(
      tx.isIncome ? tx.amount : -tx.amount,
      tx.currency,
      sign: tx.isIncome,
    );

/// Net spending per currency: expenses minus refunds, ordered with the
/// largest total first.
List<MapEntry<String, double>> spaceSpendingByCurrency(
  Iterable<SpaceTransactionEntity> txs,
) {
  final totals = <String, double>{};
  for (final tx in txs) {
    if (tx.isIncome && !tx.isRefund) continue;
    final delta = tx.isRefund ? -tx.amount : tx.amount;
    totals.update(tx.currency, (v) => v + delta, ifAbsent: () => delta);
  }
  final list = totals.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return list;
}

Color spaceBudgetColor(AppTones t, double ratio) {
  if (ratio >= 1) return t.expenseColor;
  if (ratio >= 0.85) return t.accentWarm;
  return t.brandFill;
}

double spaceBudgetRatio(SpaceBudgetEntity b) =>
    b.limit <= 0 ? 0 : (b.spent / b.limit).clamp(0, 10).toDouble();
