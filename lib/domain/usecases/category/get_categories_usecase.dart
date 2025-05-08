import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/repositories/category_repository.dart';

@injectable
class GetCategoriesUseCase implements UseCase<void, NoParams> {
  final CategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await _repository.getAllCategories();
  }
}
