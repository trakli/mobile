import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

class ShareTransactionToSpaceParams {
  final String slug;
  final int transactionId;
  final List<int> categoryIds;
  const ShareTransactionToSpaceParams({
    required this.slug,
    required this.transactionId,
    this.categoryIds = const [],
  });
}

@injectable
class ShareTransactionToSpaceUseCase implements UseCase<SpaceTransactionEntity, ShareTransactionToSpaceParams> {
  final SpaceRepository repository;

  ShareTransactionToSpaceUseCase(this.repository);

  @override
  Future<Either<Failure, SpaceTransactionEntity>> call(ShareTransactionToSpaceParams params) {
    return repository.shareTransaction(
      params.slug,
      transactionId: params.transactionId,
      categoryIds: params.categoryIds,
    );
  }
}
