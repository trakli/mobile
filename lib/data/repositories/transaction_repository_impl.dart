import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/database/app_database.dart';
import 'package:trakli/data/datasources/transaction/transaction_local_datasource.dart';
import 'package:trakli/data/mapper/transaction_mapper.dart';
import 'package:trakli/data/sync/transaction_type_handler.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/error/failures/failures.dart';
import '../../domain/repositories/transaction_repository.dart';

// class TransactionRepositoryImpl implements TransactionRepository {
// final TransactionLocalDataSource localDataSource;
// final TransactionRemoteDataSource remoteDataSource;

//   TransactionRepositoryImpl({
//     required this.localDataSource,
//     required this.remoteDataSource,
//   });

// @override
// Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
//   try {
//     final transactions = await localDataSource.getAllTransactions();
//     return Right(transactions);
//   } catch (e) {
//     return Left(Failure.cacheError(e.toString()));
//   }
// }

// @override
// Future<Either<Failure, Unit>> insertTransaction(
//   double amount,
//   String description,
//   String title,
//   String category,
// ) async {
//   try {
//     await localDataSource.insertTransaction(
//       amount,
//       description,
//       title,
//       category,
//     );
//     return const Right(unit);
//   } catch (e) {
//     return Left(Failure.cacheError(e.toString()));
//   }
// }

// @override
// Future<Either<Failure, Unit>> updateTransaction(
//   String id,
//   double? amount,
//   String? description,
//   String? category,
// ) async {
//   try {
//     await localDataSource.updateTransaction(
//       id,
//       amount,
//       description,
//       category,
//     );
//     return const Right(unit);
//   } catch (e) {
//     return Left(Failure.cacheError(e.toString()));
//   }
// }

//   @override
//   Future<Either<Failure, Unit>> deleteTransaction(String id) async {
//     try {
//       await localDataSource.deleteTransaction(id);
//       return const Right(unit);
//     } catch (e) {
//       return Left(Failure.cacheError(e.toString()));
//     }
//   }

// }

// lib/data/repositories/transaction_repository_impl.dart
// import 'package:drift_sync_core/drift_sync_core.dart';
// import 'package:injectable/injectable.dart';
// import 'package:transaction_tracker/data/datasources/local/database.dart';
// import 'package:transaction_tracker/domain/entities/transaction.dart';
// import 'package:transaction_tracker/domain/repositories/transaction_repository.dart';
// import 'package:transaction_tracker/data/sync/transaction_type_handler.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl
    extends SyncEntityRepository<AppDatabase, Transaction, String>
    implements TransactionRepository {
  TransactionRepositoryImpl({
    required TransactionTypeHandler syncHandler,
    required this.localDataSource,
    required super.db,
  }) : super(syncHandler: syncHandler);

  // final DriftSynchronizer<AppDatabase> synchronizer;
  final TransactionLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Unit>> updateTransaction(
    String id,
    double? amount,
    String? description,
    String? category,
  ) async {
    try {
      final transaction = await localDataSource.updateTransaction(
        id,
        amount,
        description,
        category,
      );

      unawaited(put(transaction));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      final transaction = await localDataSource.deleteTransaction(id);

      unawaited(delete(transaction));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertTransaction(
    double amount,
    String description,
    String category,
  ) async {
    try {
      final transaction = await localDataSource.insertTransaction(
          amount, description, category);

      unawaited(put(transaction));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
    try {
      final transactions = await localDataSource.getAllTransactions();
      return Right(TransactionMapper.toDomainList(transactions));
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<TransactionEntity>>> listenToTransactions() {
    return localDataSource.listenToTransaction().map((transactions) {
      return Right(TransactionMapper.toDomainList(transactions));
    });
  }
}
