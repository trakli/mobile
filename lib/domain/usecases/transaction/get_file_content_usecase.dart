import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/repositories/media_repository.dart';

@injectable
class GetFileContentUseCase implements UseCase<String, GetFileContentParams> {
  final MediaRepository repository;

  GetFileContentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(GetFileContentParams params) async {
    return repository.getFileContent(params.fileId);
  }
}

class GetFileContentParams {
  final int fileId;

  GetFileContentParams({required this.fileId});
}
