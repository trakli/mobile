import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';

import '../../entities/transaction_entity.dart';
import '../../repositories/transaction_repository.dart';

@injectable
class ListenToTransactionsUseCase {
  final TransactionRepository repository;

  ListenToTransactionsUseCase(this.repository);

  Stream<Either<Failure, List<TransactionEntity>>> call() {
    return repository.listenToTransactions();
  }
}
