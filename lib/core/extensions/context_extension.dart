import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

extension BuildContextExtension on BuildContext {
  /// Gets the default wallet ID from config
  /// Returns null if no default wallet is configured
  String? getDefaultWalletId() {
    final configState = read<ConfigCubit>().state;
    return configState.getConfigByKey(ConfigConstants.defaultWallet)?.value
        as String?;
  }

  /// Gets the default wallet from config
  /// Returns null if no default wallet is configured or wallet is not found
  WalletEntity? getDefaultWallet() {
    final defaultWalletId = getDefaultWalletId();

    if (defaultWalletId == null) {
      return null;
    }

    final wallets = read<WalletCubit>().state.wallets;
    return wallets.firstWhereOrNull(
      (wallet) => wallet.clientId == defaultWalletId,
    );
  }
}
