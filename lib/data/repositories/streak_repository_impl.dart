import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/streak/streak_remote_datasource.dart';
import 'package:trakli/domain/entities/streak_entity.dart';
import 'package:trakli/domain/repositories/streak_repository.dart';

@LazySingleton(as: StreakRepository)
class StreakRepositoryImpl implements StreakRepository {
  final StreakRemoteDataSource _remote;

  StreakRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<StreakEntity>>> getStreaks() {
    return RepositoryErrorHandler.handleApiCall(() async {
      final items = await _remote.getStreaks();
      return items
          .map((item) => item.toEntity())
          .whereType<StreakEntity>()
          .toList();
    });
  }
}
