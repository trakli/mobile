import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/presentation/utils/enums.dart';
import '../entities/transaction_entity.dart';
import 'dart:async';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions();

  Future<Either<Failure, Unit>> insertTransaction(
    double amount,
    String description,
    String categoryId,
    TransactionType type,
    DateTime datetime,
  );
  Future<Either<Failure, Unit>> updateTransaction(
    String id,
    double? amount,
    String? description,
    String? category,
  );
  Future<Either<Failure, Unit>> deleteTransaction(String id);

  Stream<Either<Failure, List<TransactionEntity>>> listenToTransactions();
}
