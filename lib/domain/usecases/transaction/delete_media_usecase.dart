import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/media_repository.dart';

@injectable
class DeleteMediaUseCase implements UseCase<Unit, DeleteMediaParams> {
  final MediaRepository repository;

  DeleteMediaUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteMediaParams params) async {
    return repository.deleteMediaByPath(params.path);
  }
}

class DeleteMediaParams {
  final String path;

  DeleteMediaParams({required this.path});
}
