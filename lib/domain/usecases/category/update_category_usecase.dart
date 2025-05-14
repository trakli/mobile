import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
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
      userId: params.userId,
      description: params.description,
    );
  }
}

class UpdateCategoryUseCaseParams {
  final String clientId;
  final String? name;
  final String? slug;
  final int? userId;
  final String? description;

  UpdateCategoryUseCaseParams({
    required this.clientId,
    this.name,
    this.slug,
    this.userId,
    this.description,
  });
}
