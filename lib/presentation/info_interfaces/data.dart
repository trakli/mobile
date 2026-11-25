import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';

const emptyPartyData = EmptyStateModel(
  icon: LucideIcons.usersRound,
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
      icon: LucideIcons.usersRound,
      description: LocaleKeys.emptyPartyInfo2,
    ),
    Steps(
      icon: LucideIcons.chartColumn,
      description: LocaleKeys.emptyPartyInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyPartyButtonText,
  buttonText1: LocaleKeys.addParties,
  tipText: LocaleKeys.emptyPartyTipText,
);

const emptyCategoryData = EmptyStateModel(
  icon: LucideIcons.tag,
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
      icon: LucideIcons.tag,
      description: LocaleKeys.emptyCategoryInfo1,
    ),
    Steps(
      icon: LucideIcons.clipboardList,
      description: LocaleKeys.emptyCategoryInfo2,
    ),
    Steps(
      icon: LucideIcons.search,
      description: LocaleKeys.emptyCategoryInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyCategoryButtonText,
  buttonText1: LocaleKeys.manageCategories,
  tipText: LocaleKeys.emptyCategoryTipText,
);

const emptyWalletData = EmptyStateModel(
  icon: LucideIcons.wallet,
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
      icon: LucideIcons.landmark,
      description: LocaleKeys.emptyWalletInfo1,
    ),
    Steps(
      icon: LucideIcons.creditCard,
      description: LocaleKeys.emptyWalletInfo2,
    ),
    Steps(
      icon: LucideIcons.trendingUp,
      description: LocaleKeys.emptyWalletInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyWalletButtonText,
  buttonText1: LocaleKeys.setupWallet,
  tipText: LocaleKeys.emptyWalletTipText,
);

const emptyTransactionData = EmptyStateModel(
  icon: LucideIcons.arrowLeftRight,
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
      icon: LucideIcons.circleDollarSign,
      description: LocaleKeys.emptyTransactionInfo1,
    ),
    Steps(
      icon: LucideIcons.chartColumn,
      description: LocaleKeys.emptyTransactionInfo2,
    ),
    Steps(
      icon: LucideIcons.locateFixed,
      description: LocaleKeys.emptyTransactionInfo3,
    ),
  ],
  buttonText: LocaleKeys.emptyTransactionButtonText,
  buttonText1: LocaleKeys.addTransaction,
  tipText: LocaleKeys.emptyTransactionTipText,
);

const youAllSetData = EmptyStateModel(
  icon: LucideIcons.arrowLeftRight,
  title: LocaleKeys.youAllSetTitleOne,
  description: LocaleKeys.youAllSetDescriptionOne,
  quickStartSteps: [],
  quickSteps: [
    Steps(
      icon: LucideIcons.trophy, // Represents a reward/achievement
      description: LocaleKeys.youAllSetInfo1,
    ),
    Steps(
      icon: LucideIcons.smartphone,
      description: LocaleKeys.youAllSetInfo2,
    ),
    Steps(
      icon: LucideIcons.lightbulb,
      description: LocaleKeys.youAllSetInfo3,
    ),
  ],
  buttonText: "",
  buttonText1: LocaleKeys.startUsingTrakli,
);
