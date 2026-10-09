import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/streak_entity.dart';
import 'package:trakli/domain/repositories/streak_repository.dart';

@injectable
class GetStreaksUseCase implements UseCase<List<StreakEntity>, NoParams> {
  final StreakRepository repository;

  GetStreaksUseCase(this.repository);

  @override
  Future<Either<Failure, List<StreakEntity>>> call(NoParams params) {
    return repository.getStreaks();
  }
}
