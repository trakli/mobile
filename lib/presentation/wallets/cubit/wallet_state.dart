part of 'wallet_cubit.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState({
    required List<WalletEntity> wallets,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
    @Default(0) int currentSelectedWalletIndex,
  }) = _WalletState;

  factory WalletState.initial() => const WalletState(
        wallets: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: Failure.none(),
      );
}
