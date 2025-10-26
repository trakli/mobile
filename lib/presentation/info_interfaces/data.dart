import 'package:flutter/material.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';

const emptyPartyData = EmptyStateModel(
  icon: Icons.people_outline,
  title: "Track Who You Deal With",
  description:
      "Parties are people or businesses you exchange money with. This helps you see spending patterns with specific vendors.",
  quickStartSteps: [
    "Add common payees (e.g., 'Grocery Store', 'Landlord')",
    "Include income sources (e.g., 'Employer', 'Client Name')",
    "Use them in transactions for better insights",
  ],
  buttonText: "Add First Party",
  tipText:
      "💡 Start with your most frequent payees - your employer, grocery store, or landlord!",
);

const emptyCategoryData = EmptyStateModel(
  icon: Icons.label_outline,
  title: "Organize Your Money with Categories",
  description:
      "Categories help you understand where your money comes from and where it goes. Let's start with some basics!",
  quickStartSteps: [
    "Create income categories (e.g., 'Salary', 'Freelance')",
    "Add expense categories (e.g., 'Food', 'Transport')",
    "Use them when adding transactions",
  ],
  buttonText: "Add First Category",
  tipText:
      "💡 Don't worry about getting it perfect — you can always add more categories later!",
);

const emptyWalletData = EmptyStateModel(
  icon: Icons.account_balance_wallet_outlined,
  title: "Let's Set Up Your First Wallet",
  description:
      "Wallets help you organize your money across different accounts like bank accounts, cash, or digital wallets.",
  quickStartSteps: [
    "Create your first wallet (e.g., 'Main Bank Account')",
    "Add your current balance",
    "Start tracking transactions",
  ],
  buttonText: "Add First Wallet",
  tipText:
      "💡 Start with your main bank account — you can add more wallets later!",
);

const emptyTransactionData = EmptyStateModel(
  icon: Icons.compare_arrows_outlined,
  title: "Ready to Track Your First Transaction?",
  description:
      "Transactions are the heart of expense tracking. Each transaction tells the story of your money's journey.",
  quickStartSteps: [
    "Click 'Add Transaction' above",
    "Choose income or expense",
    "Select wallet and category",
    "Add amount and description",
  ],
  buttonText: "Add First Transaction",
  tipText:
      "💡 Pro tip: Start by adding your most recent transactions to get into the habit!",
);
