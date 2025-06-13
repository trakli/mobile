import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'dart:async';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionCompleteEntity>>> getAllTransactions();

  Future<Either<Failure, Unit>> insertTransaction(
    double amount,
    String description,
    List<String> categoryIds,
    TransactionType type,
    DateTime datetime,
    String walletClientId, {
    String? partyClientId,
    String? groupClientId,
  });

  Future<Either<Failure, Unit>> updateTransaction(
    String id,
    double? amount,
    String? description,
    List<String>? categoryIds,
    DateTime? datetime,
    String? walletClientId, {
    String? partyClientId,
    String? groupClientId,
  });

  Future<Either<Failure, Unit>> deleteTransaction(String id);

  Stream<Either<Failure, List<TransactionCompleteEntity>>>
      listenToTransactions();
}
