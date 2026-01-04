import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

void main() {
  group('WalletState', () {
    group('allWalletsIndex constant', () {
      test('should be -1', () {
        expect(allWalletsIndex, equals(-1));
      });
    });

    group('initial state', () {
      test('should have currentSelectedWalletIndex set to allWalletsIndex', () {
        final state = WalletState.initial();

        expect(state.currentSelectedWalletIndex, equals(allWalletsIndex));
      });

      test('should have empty wallets list', () {
        final state = WalletState.initial();

        expect(state.wallets, isEmpty);
      });

      test('should not be loading', () {
        final state = WalletState.initial();

        expect(state.isLoading, isFalse);
      });
    });

    group('isAllWalletsSelected', () {
      test('should return true when currentSelectedWalletIndex is -1', () {
        const state = WalletState(
          wallets: [],
          isLoading: false,
          isSaving: false,
          isDeleting: false,
          failure: Failure.none(),
          currentSelectedWalletIndex: -1,
        );

        expect(state.isAllWalletsSelected, isTrue);
      });

      test('should return false when currentSelectedWalletIndex is 0', () {
        const state = WalletState(
          wallets: [],
          isLoading: false,
          isSaving: false,
          isDeleting: false,
          failure: Failure.none(),
          currentSelectedWalletIndex: 0,
        );

        expect(state.isAllWalletsSelected, isFalse);
      });

      test('should return false when currentSelectedWalletIndex is positive',
          () {
        const state = WalletState(
          wallets: [],
          isLoading: false,
          isSaving: false,
          isDeleting: false,
          failure: Failure.none(),
          currentSelectedWalletIndex: 5,
        );

        expect(state.isAllWalletsSelected, isFalse);
      });
    });

    group('copyWith', () {
      test('should update currentSelectedWalletIndex to allWalletsIndex', () {
        const state = WalletState(
          wallets: [],
          isLoading: false,
          isSaving: false,
          isDeleting: false,
          failure: Failure.none(),
          currentSelectedWalletIndex: 2,
        );

        final newState =
            state.copyWith(currentSelectedWalletIndex: allWalletsIndex);

        expect(newState.currentSelectedWalletIndex, equals(allWalletsIndex));
        expect(newState.isAllWalletsSelected, isTrue);
      });

      test('should update currentSelectedWalletIndex to a wallet index', () {
        final state = WalletState.initial();

        final newState = state.copyWith(currentSelectedWalletIndex: 3);

        expect(newState.currentSelectedWalletIndex, equals(3));
        expect(newState.isAllWalletsSelected, isFalse);
      });
    });
  });
}
