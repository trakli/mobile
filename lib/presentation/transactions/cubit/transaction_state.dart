part of 'transaction_cubit.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState({
    required List<TransactionCompleteEntity> transactions,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
    GroupEntity? selectedGroup,
  }) = _TransactionState;

  factory TransactionState.initial() => const TransactionState(
        transactions: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: Failure.none(),
      );
}
