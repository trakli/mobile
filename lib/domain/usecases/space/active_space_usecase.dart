import 'package:injectable/injectable.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

@injectable
class GetActiveSpaceSlugUseCase {
  final SpaceRepository repository;

  GetActiveSpaceSlugUseCase(this.repository);

  Future<String?> call() => repository.getActiveSpaceSlug();
}

@injectable
class SetActiveSpaceSlugUseCase {
  final SpaceRepository repository;

  SetActiveSpaceSlugUseCase(this.repository);

  Future<void> call(String? slug) => repository.setActiveSpaceSlug(slug);
}
