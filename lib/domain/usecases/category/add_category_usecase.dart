import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/domain/repositories/category_repository.dart';

@injectable
class AddCategoryUseCase implements UseCase<Unit, AddCategoryUseCaseParams> {
  final CategoryRepository _repository;

  AddCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(AddCategoryUseCaseParams params) async {
    return await _repository.insertCategory(
      params.name,
      params.slug,
      params.type,
      params.userId,
      description: params.description,
    );
  }
}

class AddCategoryUseCaseParams {
  final String name;
  final String slug;
  final CategoryType type;
  final int userId;
  final String? description;

  AddCategoryUseCaseParams({
    required this.description,
    required this.name,
    required this.slug,
    required this.type,
    required this.userId,
  });
}
