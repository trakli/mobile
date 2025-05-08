import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/category_repository.dart';

@injectable
class DeleteCategoryUseCase implements UseCase<Unit, String> {
  final CategoryRepository _repository;

  DeleteCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String clientId) async {
    return await _repository.deleteCategory(clientId);
  }
}
