import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/utils/currency_formater.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';

/// Converts transactions into the currency the statistics are shown in and
/// formats amounts in it.
class StatsMoney {
  final String currency;
  final double Function(TransactionCompleteEntity) convert;

  const StatsMoney({required this.currency, required this.convert});

  factory StatsMoney.of(BuildContext context) {
    final rates = context.watch<ExchangeRateCubit>().state.entity;
    final fallback =
        context.watch<CurrencyCubit>().state.currency?.code ?? 'EUR';
    if (rates == null) {
      return StatsMoney(
        currency: fallback,
        convert: (t) => t.transaction.amount,
      );
    }
    return StatsMoney(
      currency: rates.baseCode,
      convert: (t) => calculateSingleTransactionTotal(t, rates),
    );
  }

  String full(double v, {bool sign = false}) =>
      LedgerMoney.format(v, currency, sign: sign);

  String short(double v) => LedgerMoney.format(v, currency, decimals: 0);
}
