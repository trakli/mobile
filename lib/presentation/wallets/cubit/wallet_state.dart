part of 'wallet_cubit.dart';

const int allWalletsIndex = -1;

@freezed
class WalletState with _$WalletState {
  const factory WalletState({
    required List<WalletEntity> wallets,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
    @Default(allWalletsIndex) int currentSelectedWalletIndex,
  }) = _WalletState;

  factory WalletState.initial() => const WalletState(
        wallets: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: Failure.none(),
      );

  const WalletState._();

  bool get isAllWalletsSelected => currentSelectedWalletIndex == allWalletsIndex;
}
