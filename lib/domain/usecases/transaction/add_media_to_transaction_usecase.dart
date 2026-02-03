import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/media_repository.dart';

@injectable
class AddMediaToTransactionUseCase
    implements UseCase<Unit, AddMediaToTransactionParams> {
  final MediaRepository repository;

  AddMediaToTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddMediaToTransactionParams params) async {
    return repository.addMediaToTransaction(
      params.transactionClientId,
      params.filePath,
    );
  }
}

class AddMediaToTransactionParams {
  final String transactionClientId;
  final String filePath;

  AddMediaToTransactionParams({
    required this.transactionClientId,
    required this.filePath,
  });
}
