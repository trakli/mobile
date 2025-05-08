import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/repositories/category_repository.dart';

@injectable
class ListenToCategoriesUseCase
    implements StreamUseCase<List<CategoryEntity>, NoParams> {
  final CategoryRepository repository;

  ListenToCategoriesUseCase(this.repository);

  @override
  Stream<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return repository.listenToCategories();
  }
}
