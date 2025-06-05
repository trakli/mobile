import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/transaction_repository.dart';

@injectable
class UpdateTransactionUseCase
    implements UseCase<Unit, UpdateTransactionParams> {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateTransactionParams params) async {
    return repository.updateTransaction(
      params.id,
      params.amount,
      params.description,
      params.categoryIds,
      params.datetime,
      params.walletClientId,
      partyClientId: params.partyClientId,
    );
  }
}

class UpdateTransactionParams {
  final String id;
  final double? amount;
  final String? description;
  final List<String>? categoryIds;
  final DateTime? datetime;
  final String? walletClientId;
  final String? partyClientId;

  UpdateTransactionParams({
    required this.id,
    this.amount,
    this.description,
    this.categoryIds,
    this.datetime,
    this.walletClientId,
    this.partyClientId,
  });
}
