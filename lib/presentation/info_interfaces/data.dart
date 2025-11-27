import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';

const emptyPartyData = EmptyStateModel(
  icon: Icons.people_outline,
  title: LocaleKeys.emptyPartyTitle,
  title1: LocaleKeys.emptyPartyTitleOne,
  description: LocaleKeys.emptyPartyDescription,
  description1: LocaleKeys.emptyPartyDescriptionOne,
  quickStartSteps: [
    LocaleKeys.emptyPartyStep1,
    LocaleKeys.emptyPartyStep2,
    LocaleKeys.emptyPartyStep3,
  ],
  quickSteps: [
    Steps(
      icon: FontAwesomeIcons.cartShopping,
      description: LocaleKeys.emptyPartyInfo1,
    ),
    Steps(
      icon: Icons.people,
      description: LocaleKeys.emptyPartyInfo2,
    ),
    Steps(
      icon: Icons.bar_chart,
      description: LocaleKeys.emptyPartyInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyPartyButtonText,
  buttonText1: LocaleKeys.addParties,
  tipText: LocaleKeys.emptyPartyTipText,
);

const emptyCategoryData = EmptyStateModel(
  icon: Icons.label_outline,
  title: LocaleKeys.emptyCategoryTitle,
  title1: LocaleKeys.emptyCategoryTitleOne,
  description: LocaleKeys.emptyCategoryDescription,
  description1: LocaleKeys.emptyCategoryDescriptionOne,
  quickStartSteps: [
    LocaleKeys.emptyCategoryStep1,
    LocaleKeys.emptyCategoryStep2,
    LocaleKeys.emptyCategoryStep3,
  ],
  quickSteps: [
    Steps(
      icon: Icons.local_offer,
      description: LocaleKeys.emptyCategoryInfo1,
    ),
    Steps(
      icon: Icons.assignment,
      description: LocaleKeys.emptyCategoryInfo2,
    ),
    Steps(
      icon: Icons.search,
      description: LocaleKeys.emptyCategoryInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyCategoryButtonText,
  buttonText1: LocaleKeys.manageCategories,
  tipText: LocaleKeys.emptyCategoryTipText,
);

const emptyWalletData = EmptyStateModel(
  icon: Icons.account_balance_wallet_outlined,
  title: LocaleKeys.emptyWalletTitle,
  title1: LocaleKeys.emptyWalletTitleOne,
  description: LocaleKeys.emptyWalletDescription,
  description1: LocaleKeys.emptyWalletDescriptionOne,
  quickStartSteps: [
    LocaleKeys.emptyWalletStep1,
    LocaleKeys.emptyWalletStep2,
    LocaleKeys.emptyWalletStep3,
  ],
  quickSteps: [
    Steps(
      icon: Icons.account_balance,
      description: LocaleKeys.emptyWalletInfo1,
    ),
    Steps(
      icon: Icons.credit_card,
      description: LocaleKeys.emptyWalletInfo2,
    ),
    Steps(
      icon: Icons.trending_up,
      description: LocaleKeys.emptyWalletInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyWalletButtonText,
  buttonText1: LocaleKeys.setupWallet,
  tipText: LocaleKeys.emptyWalletTipText,
);

const emptyTransactionData = EmptyStateModel(
  icon: Icons.compare_arrows_outlined,
  title: LocaleKeys.emptyTransactionTitle,
  title1: LocaleKeys.emptyTransactionTitleOne,
  description: LocaleKeys.emptyTransactionDescription,
  description1: LocaleKeys.emptyTransactionDescriptionOne,
  quickStartSteps: [
    LocaleKeys.emptyTransactionStep1,
    LocaleKeys.emptyTransactionStep2,
    LocaleKeys.emptyTransactionStep3,
    LocaleKeys.emptyTransactionStep4,
  ],
  quickSteps: [
    Steps(
      icon: Icons.monetization_on,
      description: LocaleKeys.emptyTransactionInfo1,
    ),
    Steps(
      icon: Icons.bar_chart,
      description: LocaleKeys.emptyTransactionInfo2,
    ),
    Steps(
      icon: Icons.my_location,
      description: LocaleKeys.emptyTransactionInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyTransactionButtonText,
  buttonText1: LocaleKeys.addTransaction,
  tipText: LocaleKeys.emptyTransactionTipText,
);

const youAllSetData = EmptyStateModel(
  icon: Icons.compare_arrows_outlined,
  title: LocaleKeys.youAllSetTitleOne,
  description: LocaleKeys.youAllSetDescriptionOne,
  quickStartSteps: [],
  quickSteps: [
    Steps(
      icon: Icons.emoji_events, // Represents a reward/achievement
      description: LocaleKeys.youAllSetInfo1,
    ),
    Steps(
      icon: Icons.smartphone,
      description: LocaleKeys.youAllSetInfo2,
    ),
    Steps(
      icon: Icons.lightbulb_outline,
      description: LocaleKeys.youAllSetInfo3,
    ),
  ],
  buttonText: "",
  buttonText1: LocaleKeys.startUsingTrakli,
);
