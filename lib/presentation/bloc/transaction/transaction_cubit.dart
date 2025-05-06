import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/domain/entities/transaction_entity.dart';
import 'package:trakli/domain/usecases/transaction/usecase.dart';

part 'transaction_cubit.freezed.dart';
part 'transaction_state.dart';

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
  }) : super(const TransactionState.initial()) {
    _transactionSubscription = listenToTransactionsUseCase().listen(
      (either) => either.fold(
        (failure) => emit(TransactionState.error(failure)),
        (transactions) => emit(TransactionState.loaded(transactions)),
      ),
    );
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }

  Future<void> loadTransactions() async {
    emit(const TransactionState.loading());
    final result = await getAllTransactionsUseCase(NoParams());
    result.fold(
      (failure) => emit(TransactionState.error(failure)),
      (transactions) => emit(TransactionState.loaded(transactions)),
    );
  }

  Future<void> addTransaction({
    required double amount,
    required String description,
    required String category,
    required TransactionType type,
    required DateTime datetime,
  }) async {
    emit(const TransactionState.loading());
    final result = await createTransactionUseCase(
      CreateTransactionParams(
        amount: amount,
        description: description,
        category: category,
        type: type,
        datetime: datetime,
      ),
    );
    result.fold(
      (failure) => emit(TransactionState.error(failure)),
      (_) => loadTransactions(),
    );
  }

  Future<void> updateTransaction({
    required String id,
    double? amount,
    String? description,
    String? category,
  }) async {
    emit(const TransactionState.loading());
    final result = await updateTransactionUseCase(
      UpdateTransactionParams(
        id: id,
        amount: amount,
        description: description,
        category: category,
      ),
    );
    result.fold(
      (failure) => emit(TransactionState.error(failure)),
      (_) => loadTransactions(),
    );
  }

  Future<void> deleteTransaction(String id) async {
    emit(const TransactionState.loading());
    final result = await deleteTransactionUseCase(id);
    result.fold(
      (failure) => emit(TransactionState.error(failure)),
      (_) => loadTransactions(),
    );
  }

  Future<void> listenForChanges() async {
    emit(const TransactionState.loading());

    _transactionSubscription = listenToTransactionsUseCase().listen(
      (either) => either.fold(
        (failure) => emit(TransactionState.error(failure)),
        (transactions) => emit(TransactionState.loaded(transactions)),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:trakli/core/error/failures/failures.dart';
// import 'package:trakli/domain/entities/transaction_entity.dart';
// import 'package:trakli/domain/usecases/transaction/create_transaction_usecase.dart';
// import 'package:trakli/domain/usecases/transaction/delete_transaction_usecase.dart';
// import 'package:trakli/domain/usecases/transaction/get_all_transactions_usecase.dart';
// import 'package:trakli/domain/usecases/transaction/update_transaction_usecase.dart';
// import 'package:trakli/domain/usecases/listen_to_transactions_usecase.dart';

// part 'transaction_bloc.freezed.dart';
// part 'transaction_event.dart';
// part 'transaction_state.dart';

// class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
//   final GetAllTransactionsUseCase getAllTransactions;
//   final CreateTransactionUseCase createTransaction;
//   final UpdateTransactionUseCase updateTransaction;
//   final DeleteTransactionUseCase deleteTransaction;
//   final ListenToTransactionsUseCase listenToTransactions;
//   StreamSubscription? _transactionSubscription;

//   TransactionBloc({
//     required this.getAllTransactions,
//     required this.createTransaction,
//     required this.updateTransaction,
//     required this.deleteTransaction,
//     required this.listenToTransactions,
//   }) : super(const TransactionState.initial()) {
//     on<TransactionEvent>((event, emit) async {
//       await event.map(
//         getAllTransactions: (e) => _onGetAllTransactions(e, emit),
//         updateTransactions: (e) => _onUpdateTransactions(e, emit),
//         insertTransaction: (e) => _onInsertTransaction(e, emit),
//         updateTransaction: (e) => _onUpdateTransaction(e, emit),
//         deleteTransaction: (e) => _onDeleteTransaction(e, emit),
//       );
//     });
//     _transactionSubscription = listenToTransactions().listen(
//       (either) => either.fold(
//         (failure) => {},
//         (transactions) =>
//             add(TransactionEvent.updateTransactions(transactions)),
//       ),
//     );
//   }

//   @override
//   Future<void> close() {
//     _transactionSubscription?.cancel();
//     return super.close();
//   }

//   Future<void> _onGetAllTransactions(
//     GetAllTransactions event,
//     Emitter<TransactionState> emit,
//   ) async {
//     emit(const TransactionState.loading());
//     final result = await getAllTransactions();
//     result.fold(
//       (failure) => emit(TransactionState.error(failure)),
//       (transactions) => emit(TransactionState.loaded(transactions)),
//     );
//   }

//   Future<void> _onUpdateTransactions(
//     UpdateTransaction event,
//     Emitter<TransactionState> emit,
//   ) async {
//     emit(TransactionState.loaded(event.transactions));
//   }

//   Future<void> _onInsertTransaction(
//     InsertTransaction event,
//     Emitter<TransactionState> emit,
//   ) async {
//     emit(const TransactionState.loading());
//     final result = await createTransaction(
//       CreateTransactionParams(
//         amount: event.amount,
//         description: event.description,
//         title: event.title,
//         category: event.category,
//       ),
//     );
//     result.fold(
//       (failure) => emit(TransactionState.error(failure)),
//       (_) => add(const TransactionEvent.getAllTransactions()),
//     );
//   }

//   Future<void> _onUpdateTransaction(
//     UpdateTransaction event,
//     Emitter<TransactionState> emit,
//   ) async {
//     emit(const TransactionState.loading());
//     final result = await updateTransaction(
//       UpdateTransactionParams(
//         id: event.id,
//         amount: event.amount,
//         description: event.description,
//         category: event.category,
//       ),
//     );
//     result.fold(
//       (failure) => emit(TransactionState.error(failure)),
//       (_) => add(const TransactionEvent.getAllTransactions()),
//     );
//   }

//   Future<void> _onDeleteTransaction(
//     DeleteTransaction event,
//     Emitter<TransactionState> emit,
//   ) async {
//     emit(const TransactionState.loading());
//     final result = await deleteTransaction(event.id);
//     result.fold(
//       (failure) => emit(TransactionState.error(failure)),
//       (_) => add(const TransactionEvent.getAllTransactions()),
//     );
//   }

  // Future<void> listenForChanges() async {
  //   emit(state.copyWith(isLoading: true));
  //   _notesSubscription = _repo.listenToScratchNotes().listen(
  //     (failureOrNotes) {
  //       failureOrNotes.fold(
  //         (failure) => emit(
  //           state.copyWith(
  //             isLoading: false,
  //             failure: failure,
  //           ),
  //         ),
  //         (scratchNotes) => emit(
  //           state.copyWith(
  //             isLoading: false,
  //             failure: Failure.none(),
  //             notes: scratchNotes,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
// }
