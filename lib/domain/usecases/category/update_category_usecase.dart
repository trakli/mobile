import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/domain/repositories/category_repository.dart';

@injectable
class UpdateCategoryUseCase
    implements UseCase<Unit, UpdateCategoryUseCaseParams> {
  final CategoryRepository _repository;

  UpdateCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateCategoryUseCaseParams params) async {
    return await _repository.updateCategory(
      params.clientId,
      name: params.name,
      slug: params.slug,
      type: params.type,
      userId: params.userId,
      description: params.description,
    );
  }
}

class UpdateCategoryUseCaseParams {
  final String clientId;
  final String? name;
  final String? slug;
  final CategoryType? type;
  final int? userId;
  final String? description;

  UpdateCategoryUseCaseParams({
    required this.clientId,
    this.name,
    this.slug,
    this.type,
    this.userId,
    this.description,
  });
}
