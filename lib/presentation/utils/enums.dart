import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/home_screen.dart';
import 'package:trakli/presentation/profile_screen.dart';
import 'package:trakli/presentation/statistics_screen.dart';
import 'package:trakli/presentation/wallets/wallet_screen.dart';

enum WalletType {
  bank,
  cash,
  @JsonValue('credit_card')
  creditCard,
  mobile;

  String get customName {
    return switch (this) {
      WalletType.bank => 'Bank',
      WalletType.cash => 'Cash',
      WalletType.creditCard => 'Credit Card',
      WalletType.mobile => 'Mobile',
    };
  }

  String get serverKey {
    return switch (this) {
      WalletType.bank => 'bank',
      WalletType.cash => 'cash',
      WalletType.creditCard => 'credit_card',
      WalletType.mobile => 'mobile',
    };
  }
}

enum TransactionType {
  @JsonValue('income')
  income,
  @JsonValue('expense')
  expense;

  String get serverKey {
    return switch (this) {
      TransactionType.income => 'income',
      TransactionType.expense => 'expense',
    };
  }
}

enum NavigationScreen {
  home,
  statistics,
  wallet,
  profile;

  Widget get screen {
    switch (this) {
      case NavigationScreen.home:
        return const HomeScreen();
      case NavigationScreen.statistics:
        return const StatisticsScreen();
      case NavigationScreen.wallet:
        return const WalletScreen();
      case NavigationScreen.profile:
        return const ProfileScreen();
    }
  }
}

enum SelectIconType {
  selectIcon,
  selectEmoji,
  selectFromGalleryOrCamera,
}

enum CategorizableType { transaction }

enum DialogType {
  positive,
  negative,
}

enum PlanType {
  monthly,
  yearly,
}

enum MediaType { emoji, image, icon }

enum FilterType {
  date,
  category,
  wallet;

  String get filterName {
    return switch (this) {
      FilterType.date => 'Date',
      FilterType.category => 'Categories',
      FilterType.wallet => 'Wallets',
    };
  }
}
