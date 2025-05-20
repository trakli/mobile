import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';

class CurrencyFormatter {
  static String formatAmountWithSymbol(
    BuildContext context,
    double amount,
  ) {
    Currency? currency;

    currency = context.watch<OnboardingCubit>().state.entity?.selectedCurrency;

    final format = NumberFormat.currency(
      symbol: currency?.symbol,
      name: currency?.code,
      decimalDigits: 0,
    );

   
    return format.format(amount);
  }

  static String formatAmount(
    double amount,
  ) {
    final format = NumberFormat.currency(
      symbol: '',
      decimalDigits: 0,
    );

    return format.format(amount);
  }

  static String formatAmountCompact(
    BuildContext context,
    double amount,
  ) {
    final format = NumberFormat.compactCurrency(
      symbol: '',
      decimalDigits: 0,
    );

    // Get currency from context if provided
    Currency? currency;
    currency = context.watch<OnboardingCubit>().state.entity?.selectedCurrency;

    // Use XAF as fallback if no currency is selected
    final currencyCode = currency?.code ?? 'XAF';

    return '${format.format(amount)} $currencyCode';
  }
}
