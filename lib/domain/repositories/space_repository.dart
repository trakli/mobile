import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';

abstract class SpaceRepository {
  Future<Either<Failure, SpaceListEntity>> getSpaces();

  Future<Either<Failure, SpaceEntity>> createSpace({
    required String name,
    String? description,
  });

  Future<Either<Failure, SpaceOverviewEntity>> getOverview(String slug);

  Future<Either<Failure, SpacePage<SpaceTransactionEntity>>> getTransactions(
    String slug, {
    int page = 1,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, List<SpaceMemberEntity>>> getMembers(String slug);

  /// Shares one of the user's own transactions (by server id) into a space,
  /// then applies the space's labels when any are given.
  Future<Either<Failure, SpaceTransactionEntity>> shareTransaction(
    String slug, {
    required int transactionId,
    List<int> categoryIds = const [],
  });

  Future<Either<Failure, SpacePage<SpaceTransactionEntity>>>
      getBudgetTransactions(String slug, int budgetId, {int page = 1});

  Future<Either<Failure, Unit>> closeBudgetPeriod(String slug, int budgetId);

  Future<Either<Failure, SpaceInvitationEntity>> previewInvitation(
    String token,
  );

  Future<Either<Failure, SpaceInvitationResult>> acceptInvitation(
    String token,
  );

  Future<Either<Failure, Unit>> declineInvitation(String token);

  Future<String?> getActiveSpaceSlug();

  Future<void> setActiveSpaceSlug(String? slug);
}
