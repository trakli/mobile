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
    Currency? currency,
    bool useDefaultCurrency = false,
  }) {
    currency = currency ??
        context.watch<OnboardingCubit>().state.entity?.selectedCurrency;

    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    double amountInBaseCurrency = useDefaultCurrency
        ? convertAmountFromDefault(amount, currency, exchangeRateEntity)
        : amount;

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
    bool useDefaultCurrency = false,
    Currency? currency,
  }) {
    currency = currency ??
        context.watch<OnboardingCubit>().state.entity?.selectedCurrency;

    final exchangeRateEntity = context.watch<ExchangeRateCubit>().state.entity;

    double amountInBaseCurrency = useDefaultCurrency
        ? convertAmountFromDefault(amount, currency, exchangeRateEntity)
        : amount;

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

    final formattedAmount = format.format(amountInBaseCurrency);

    return formattedAmount;
  }

  static double convertAmountFromDefault(
    double amount,
    Currency? currency,
    ExchangeRateEntity? exchangeRateEntity, {
    bool useDefaultCurrency = false,
  }) {
    final exchangeRate = useDefaultCurrency
        ? exchangeRateEntity?.rates[currency?.code ?? 'XAF'] ?? 1
        : 1;

    final amountInBaseCurrency = amount / exchangeRate;
    return amountInBaseCurrency;
  }
}

double convertAmountToDefault(
    double amount, String? currency, ExchangeRateEntity exchangeRate) {
  final amountInBaseCurrency =
      currency != null ? amount / (exchangeRate.rates[currency] ?? 1) : amount;

  return amountInBaseCurrency;
}
