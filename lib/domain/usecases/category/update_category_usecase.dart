import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/media_entity.dart';
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
      description: params.description,
      media: params.media,
    );
  }
}

class UpdateCategoryUseCaseParams {
  final String clientId;
  final String? name;
  final String? slug;
  final int? userId;
  final String? description;
  final MediaEntity? media;

  UpdateCategoryUseCaseParams({
    required this.clientId,
    this.name,
    this.slug,
    this.userId,
    this.description,
    this.media,
  });
}
