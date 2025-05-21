import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trakli/domain/entities/exchange_rate_entity.dart';
import 'package:trakli/presentation/exchange_rate/cubit/exchange_rate_cubit.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';

const decimalDigits = 2;

class CurrencyFormater {
  static String formatAmountWithSymbol(
    BuildContext context,
    double amount, {
    bool compact = false,
    int? currentDecimalDigits,
  }) {
    Currency? currency;

    currency = context.watch<OnboardingCubit>().state.entity?.selectedCurrency;
    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    double amountInBaseCurrency =
        convertAmounFromDefault(amount, currency, exchangeRateEntity);

    if (currency?.symbolOnLeft == false) {
      NumberFormat format;
      if (compact) {
        format = NumberFormat.compactCurrency(
          symbol: '',
          decimalDigits: decimalDigits,
        );
      } else {
        format = NumberFormat.currency(
          symbol: '',
          decimalDigits: decimalDigits,
        );
      }

      final formattedAmount = format.format(amountInBaseCurrency);

      return '$formattedAmount ${currency?.symbol}';
    } else {
      NumberFormat format;
      if (compact) {
        format = NumberFormat.compactCurrency(
          symbol: currency?.symbol,
          decimalDigits: currentDecimalDigits ?? decimalDigits,
        );
      } else {
        format = NumberFormat.currency(
          symbol: currency?.symbol,
          decimalDigits: decimalDigits,
        );
      }

      return format.format(amountInBaseCurrency);
    }
  }

  static String formatAmount(
    BuildContext context,
    double amount, {
    bool compact = false,
    int? currentDecimalDigits,
  }) {
    Currency? currency =
        context.watch<OnboardingCubit>().state.entity?.selectedCurrency;

    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    double amountInBaseCurrency =
        convertAmounFromDefault(amount, currency, exchangeRateEntity);

    NumberFormat format;
    if (compact) {
      format = NumberFormat.compactCurrency(
        symbol: '',
        decimalDigits: currentDecimalDigits ?? decimalDigits,
      );
    } else {
      format = NumberFormat.currency(
        symbol: '',
        decimalDigits: currentDecimalDigits ?? decimalDigits,
      );
    }

    final cu = format.format(amountInBaseCurrency);
    return cu;
  }

  static double convertAmounFromDefault(
    double amount,
    Currency? currency,
    ExchangeRateEntity? exchangeRateEntity,
  ) {
    final exchangeRate =
        exchangeRateEntity?.rates[currency?.code ?? 'XAF'] ?? 1;

    final amountInBaseCurrency = amount * exchangeRate;
    return amountInBaseCurrency;
  }
}

double convertAmountToDefault(
    double amount, String? currency, ExchangeRateEntity exchangeRate) {
  final amountInBaseCurrency =
      currency != null ? amount / (exchangeRate.rates[currency] ?? 1) : amount;

  return amountInBaseCurrency;
}

double convertAmountFromCurrencyWihContext(
    BuildContext context, double amount, Currency? currency) {
  final exchangeRateEntity = context.read<ExchangeRateCubit>().state.entity;

  Currency? selectedCurrency = currency ??
      context.read<OnboardingCubit>().state.entity?.selectedCurrency;

  final amountInBaseCurrency = selectedCurrency != null
      ? amount * (exchangeRateEntity?.rates[selectedCurrency.code] ?? 1)
      : amount;

  return amountInBaseCurrency;
}
