import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

List<TransactionCompleteEntity> filterTransactions({
  required List<TransactionCompleteEntity> transactions,
  required List<WalletEntity> wallets,
  required int currentWalletIndex,
  required GroupEntity? selectedGroup,
  required GroupEntity? defaultGroup,
}) {
  final bool isAllWallets = currentWalletIndex == allWalletsIndex;
  final bool hasWallets = wallets.isNotEmpty;

  if (!hasWallets) return <TransactionCompleteEntity>[];

  final String? currentWalletId = isAllWallets
      ? null
      : (currentWalletIndex < wallets.length
          ? wallets[currentWalletIndex].clientId
          : null);

  if (!isAllWallets && currentWalletId == null) {
    return <TransactionCompleteEntity>[];
  }

  final String? selectedGroupId = selectedGroup?.clientId;
  final String? defaultGroupId = defaultGroup?.clientId;

  final filteredTransactions = transactions.where((transaction) {
    if (!isAllWallets && transaction.wallet.clientId != currentWalletId) {
      return false;
    }

    final String? transactionGroupId = transaction.group?.clientId;

    final bool groupMatches = transactionGroupId == selectedGroupId;
    final bool shouldUseDefaultGroup = transactionGroupId == null &&
        selectedGroupId == defaultGroupId &&
        defaultGroupId != null;

    return groupMatches || shouldUseDefaultGroup;
  }).toList();

  return filteredTransactions;
}

void main() {
  final now = DateTime.now();

  final wallet1 = WalletEntity(
    clientId: 'wallet-1',
    type: WalletType.cash,
    name: 'Cash',
    balance: 1000,
    currencyCode: 'USD',
    createdAt: now,
    updatedAt: now,
  );

  final wallet2 = WalletEntity(
    clientId: 'wallet-2',
    type: WalletType.bank,
    name: 'Bank',
    balance: 5000,
    currencyCode: 'EUR',
    createdAt: now,
    updatedAt: now,
  );

  final group1 = GroupEntity(
    clientId: 'group-1',
    name: 'Personal',
    createdAt: now,
    updatedAt: now,
  );

  final group2 = GroupEntity(
    clientId: 'group-2',
    name: 'Business',
    createdAt: now,
    updatedAt: now,
  );

  TransactionCompleteEntity createTransaction({
    required String id,
    required WalletEntity wallet,
    GroupEntity? group,
  }) {
    return TransactionCompleteEntity(
      transaction: TransactionEntity(
        clientId: id,
        amount: 100,
        description: 'Test transaction',
        createdAt: now,
        updatedAt: now,
        datetime: now,
        type: TransactionType.expense,
        walletClientId: wallet.clientId,
        groupClientId: group?.clientId,
      ),
      categories: const <CategoryEntity>[],
      wallet: wallet,
      group: group,
    );
  }

  group('filterTransactions', () {
    group('when All Wallets is selected (index = -1)', () {
      test('should return all transactions from all wallets', () {
        final transactions = [
          createTransaction(id: 'tx-1', wallet: wallet1, group: group1),
          createTransaction(id: 'tx-2', wallet: wallet2, group: group1),
          createTransaction(id: 'tx-3', wallet: wallet1, group: group1),
        ];

        final result = filterTransactions(
          transactions: transactions,
          wallets: [wallet1, wallet2],
          currentWalletIndex: allWalletsIndex,
          selectedGroup: group1,
          defaultGroup: group1,
        );

        expect(result.length, equals(3));
      });

      test('should still filter by group when All Wallets is selected', () {
        final transactions = [
          createTransaction(id: 'tx-1', wallet: wallet1, group: group1),
          createTransaction(id: 'tx-2', wallet: wallet2, group: group2),
          createTransaction(id: 'tx-3', wallet: wallet1, group: group1),
        ];

        final result = filterTransactions(
          transactions: transactions,
          wallets: [wallet1, wallet2],
          currentWalletIndex: allWalletsIndex,
          selectedGroup: group1,
          defaultGroup: group1,
        );

        expect(result.length, equals(2));
        expect(result.every((tx) => tx.group?.clientId == 'group-1'), isTrue);
      });
    });

    group('when a specific wallet is selected', () {
      test('should return only transactions from selected wallet', () {
        final transactions = [
          createTransaction(id: 'tx-1', wallet: wallet1, group: group1),
          createTransaction(id: 'tx-2', wallet: wallet2, group: group1),
          createTransaction(id: 'tx-3', wallet: wallet1, group: group1),
        ];

        final result = filterTransactions(
          transactions: transactions,
          wallets: [wallet1, wallet2],
          currentWalletIndex: 0,
          selectedGroup: group1,
          defaultGroup: group1,
        );

        expect(result.length, equals(2));
        expect(
            result.every((tx) => tx.wallet.clientId == 'wallet-1'), isTrue);
      });

      test('should filter by both wallet and group', () {
        final transactions = [
          createTransaction(id: 'tx-1', wallet: wallet1, group: group1),
          createTransaction(id: 'tx-2', wallet: wallet1, group: group2),
          createTransaction(id: 'tx-3', wallet: wallet2, group: group1),
        ];

        final result = filterTransactions(
          transactions: transactions,
          wallets: [wallet1, wallet2],
          currentWalletIndex: 0,
          selectedGroup: group1,
          defaultGroup: group1,
        );

        expect(result.length, equals(1));
        expect(result.first.transaction.clientId, equals('tx-1'));
      });
    });

    group('edge cases', () {
      test('should return empty list when wallets list is empty', () {
        final transactions = [
          createTransaction(id: 'tx-1', wallet: wallet1, group: group1),
        ];

        final result = filterTransactions(
          transactions: transactions,
          wallets: [],
          currentWalletIndex: 0,
          selectedGroup: group1,
          defaultGroup: group1,
        );

        expect(result, isEmpty);
      });

      test('should return empty list when wallet index is out of bounds', () {
        final transactions = [
          createTransaction(id: 'tx-1', wallet: wallet1, group: group1),
        ];

        final result = filterTransactions(
          transactions: transactions,
          wallets: [wallet1],
          currentWalletIndex: 5,
          selectedGroup: group1,
          defaultGroup: group1,
        );

        expect(result, isEmpty);
      });

      test('should include transactions with null group when default group is selected',
          () {
        final transactions = [
          createTransaction(id: 'tx-1', wallet: wallet1, group: null),
          createTransaction(id: 'tx-2', wallet: wallet1, group: group1),
        ];

        final result = filterTransactions(
          transactions: transactions,
          wallets: [wallet1],
          currentWalletIndex: allWalletsIndex,
          selectedGroup: group1,
          defaultGroup: group1,
        );

        expect(result.length, equals(2));
      });
    });
  });
}
