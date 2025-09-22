part of 'transaction_cubit.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState({
    required List<TransactionCompleteEntity> transactions,
    required List<WalletEntity> wallets,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
    GroupEntity? selectedGroup,
  }) = _TransactionState;

  factory TransactionState.initial() => const TransactionState(
        transactions: [],
        wallets: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: Failure.none(),
      );
}
