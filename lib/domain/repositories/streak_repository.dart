import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/streak_entity.dart';

/// Streaks are counted on the server from what reaches it; nothing is stored
/// or synced locally.
abstract class StreakRepository {
  /// Every streak the user has, at most one per type and period.
  Future<Either<Failure, List<StreakEntity>>> getStreaks();
}
