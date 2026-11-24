import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';

/// The user's display currency and the rates to reach it, read from the
/// existing config, currency and exchange-rate cubits.
class LedgerCurrency {
  final String code;
  final Map<String, double>? rates;

  const LedgerCurrency(this.code, this.rates);

  static LedgerCurrency of(BuildContext context) {
    final config = context.watch<ConfigCubit>().state;
    final fromConfig =
        config.getConfigByKey(ConfigConstants.defaultCurrency)?.value;
    final exchange = context.watch<ExchangeRateCubit>().state.entity;
    final code = (fromConfig is String && fromConfig.isNotEmpty)
        ? fromConfig
        : context.watch<CurrencyCubit>().state.currency?.code ??
            exchange?.baseCode ??
            'USD';
    return LedgerCurrency(code, exchange?.rates);
  }
}
