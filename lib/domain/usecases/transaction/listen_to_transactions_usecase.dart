import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';

import '../../repositories/transaction_repository.dart';

@injectable
class ListenToTransactionsUseCase implements StreamUseCase<void, NoParams> {
  final TransactionRepository repository;

  ListenToTransactionsUseCase(this.repository);

  @override
  Stream<Either<Failure, List<TransactionCompleteEntity>>> call(
      NoParams params) {
    return repository.listenToTransactions();
  }
}
