import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/usecases/transaction/usecase.dart';

part 'transaction_state.dart';
part 'transaction_cubit.freezed.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final GetAllTransactionsUseCase getAllTransactionsUseCase;
  final CreateTransactionUseCase createTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final ListenToTransactionsUseCase listenToTransactionsUseCase;
  StreamSubscription? _transactionSubscription;

  TransactionCubit({
    required this.getAllTransactionsUseCase,
    required this.createTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.listenToTransactionsUseCase,
  }) : super(TransactionState.initial()) {
    listenForChanges();
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }

  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));

    final result = await getAllTransactionsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: failure,
      )),
      (transactions) => emit(state.copyWith(
        isLoading: false,
        transactions: transactions,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> addTransaction({
    required double amount,
    required String description,
    List<String>? categoryIds,
    required TransactionType type,
    required DateTime datetime,
    required String walletClientId,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await createTransactionUseCase(
      CreateTransactionParams(
        amount: amount,
        description: description,
        categoryIds: categoryIds ?? [],
        type: type,
        datetime: datetime,
        walletClientId: walletClientId,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) => emit(
        state.copyWith(
          isSaving: false,
          failure: const Failure.none(),
        ),
      ),
    );
  }

  Future<void> updateTransaction({
    required String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await updateTransactionUseCase(
      UpdateTransactionParams(
        id: id,
        amount: amount,
        description: description,
        categoryIds: categoryIds,
        datetime: datetime,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isSaving: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> deleteTransaction(String id) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));

    // Optimistically update the UI
    final updatedTransactions = state.transactions
        .where((transaction) => transaction.transaction.clientId != id)
        .toList();

    emit(state.copyWith(
      transactions: updatedTransactions,
      isDeleting: true,
    ));

    final result = await deleteTransactionUseCase(id);
    result.fold(
      (failure) => emit(state.copyWith(
        isDeleting: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isDeleting: false,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> listenForChanges() async {
    emit(state.copyWith(isLoading: true));

    _transactionSubscription = listenToTransactionsUseCase(NoParams()).listen(
      (either) => either.fold(
        (failure) => emit(
          state.copyWith(
            failure: failure,
            isLoading: false,
          ),
        ),
        (transactions) => emit(
          state.copyWith(
            transactions: transactions,
            isLoading: false,
          ),
        ),
      ),
    );
  }
}
