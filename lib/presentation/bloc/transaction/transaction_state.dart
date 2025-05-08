part of 'transaction_cubit.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = Initial;
  const factory TransactionState.loading() = Loading;
  const factory TransactionState.loaded(List<TransactionEntity> transactions) =
      Loaded;
  const factory TransactionState.error(Failure failure) = Error;
}
