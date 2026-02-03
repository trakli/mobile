import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';
import 'package:trakli/domain/repositories/media_repository.dart';

@injectable
class GetMediaForTransactionUseCase
    implements UseCase<List<MediaFileEntity>, GetMediaForTransactionParams> {
  final MediaRepository repository;

  GetMediaForTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, List<MediaFileEntity>>> call(
      GetMediaForTransactionParams params) async {
    return repository.getMediaForTransaction(params.transactionClientId);
  }
}

class GetMediaForTransactionParams {
  final String transactionClientId;

  GetMediaForTransactionParams({required this.transactionClientId});
}
