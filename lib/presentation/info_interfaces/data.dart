import 'package:flutter/material.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';

const emptyPartyData = EmptyStateModel(
  icon: Icons.people_outline,
  title: LocaleKeys.emptyPartyTitle,
  description: LocaleKeys.emptyPartyDescription,
  quickStartSteps: [
    LocaleKeys.emptyPartyStep1,
    LocaleKeys.emptyPartyStep2,
    LocaleKeys.emptyPartyStep3,
  ],
  buttonText: LocaleKeys.emptyPartyButtonText,
  tipText: LocaleKeys.emptyPartyTipText,
);

const emptyCategoryData = EmptyStateModel(
  icon: Icons.label_outline,
  title: LocaleKeys.emptyCategoryTitle,
  description: LocaleKeys.emptyCategoryDescription,
  quickStartSteps: [
    LocaleKeys.emptyCategoryStep1,
    LocaleKeys.emptyCategoryStep2,
    LocaleKeys.emptyCategoryStep3,
  ],
  buttonText: LocaleKeys.emptyCategoryButtonText,
  tipText: LocaleKeys.emptyCategoryTipText,
);

const emptyWalletData = EmptyStateModel(
  icon: Icons.account_balance_wallet_outlined,
  title: LocaleKeys.emptyWalletTitle,
  description: LocaleKeys.emptyWalletDescription,
  quickStartSteps: [
    LocaleKeys.emptyWalletStep1,
    LocaleKeys.emptyWalletStep2,
    LocaleKeys.emptyWalletStep3,
  ],
  buttonText: LocaleKeys.emptyWalletButtonText,
  tipText: LocaleKeys.emptyWalletTipText,
);

const emptyTransactionData = EmptyStateModel(
  icon: Icons.compare_arrows_outlined,
  title: LocaleKeys.emptyTransactionTitle,
  description: LocaleKeys.emptyTransactionDescription,
  quickStartSteps: [
    LocaleKeys.emptyTransactionStep1,
    LocaleKeys.emptyTransactionStep2,
    LocaleKeys.emptyTransactionStep3,
    LocaleKeys.emptyTransactionStep4,
  ],
  buttonText: LocaleKeys.emptyTransactionButtonText,
  tipText: LocaleKeys.emptyTransactionTipText,
);
