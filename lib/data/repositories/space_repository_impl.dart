import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/error/repository_error_handler.dart';
import 'package:trakli/data/datasources/space/space_remote_datasource.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/repositories/space_repository.dart';

@LazySingleton(as: SpaceRepository)
class SpaceRepositoryImpl implements SpaceRepository {
  static const activeSpaceKey = 'trakli.space';

  final SpaceRemoteDataSource remote;

  SpaceRepositoryImpl({required this.remote});

  /// Spaces answer 403 when the plan does not allow a change; keep the
  /// server's explanation instead of collapsing it into an unknown error.
  Future<Either<Failure, T>> _call<T>(Future<T> Function() apiCall) async {
    try {
      return right(await apiCall());
    } on ForbiddenException catch (e) {
      return left(Failure.badRequest(error: e.message));
    } catch (e, st) {
      return RepositoryErrorHandler.handleApiCall(() => Future<T>.error(e, st));
    }
  }

  @override
  Future<Either<Failure, SpaceListEntity>> getSpaces() =>
      _call(remote.getSpaces);

  @override
  Future<Either<Failure, SpaceEntity>> createSpace({
    required String name,
    String? description,
  }) =>
      _call(
        () => remote.createSpace(name: name, description: description),
      );

  @override
  Future<Either<Failure, SpaceOverviewEntity>> getOverview(String slug) =>
      _call(() => remote.getOverview(slug));

  @override
  Future<Either<Failure, SpacePage<SpaceTransactionEntity>>> getTransactions(
    String slug, {
    int page = 1,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      _call(
        () => remote.getTransactions(
          slug,
          page: page,
          startDate: startDate,
          endDate: endDate,
        ),
      );

  @override
  Future<Either<Failure, List<SpaceMemberEntity>>> getMembers(String slug) =>
      _call(() => remote.getMembers(slug));

  @override
  Future<Either<Failure, SpaceTransactionEntity>> shareTransaction(
    String slug, {
    required int transactionId,
    List<int> categoryIds = const [],
  }) {
    return _call(() async {
      final shared = await remote.shareTransaction(slug, transactionId);
      if (categoryIds.isEmpty) return shared;
      return remote.classifyTransaction(
        slug,
        shared.id,
        categoryIds: categoryIds,
        groupIds: shared.groupIds,
      );
    });
  }

  @override
  Future<Either<Failure, SpacePage<SpaceTransactionEntity>>>
      getBudgetTransactions(String slug, int budgetId, {int page = 1}) =>
          _call(
            () => remote.getBudgetTransactions(slug, budgetId, page: page),
          );

  @override
  Future<Either<Failure, Unit>> closeBudgetPeriod(String slug, int budgetId) =>
      _call(() async {
        await remote.closeBudgetPeriod(slug, budgetId);
        return unit;
      });

  @override
  Future<Either<Failure, SpaceInvitationEntity>> previewInvitation(
    String token,
  ) =>
      _call(
        () => remote.previewInvitation(token),
      );

  @override
  Future<Either<Failure, SpaceInvitationResult>> acceptInvitation(
    String token,
  ) =>
      _call(
        () => remote.acceptInvitation(token),
      );

  @override
  Future<Either<Failure, Unit>> declineInvitation(String token) =>
      _call(() async {
        await remote.declineInvitation(token);
        return unit;
      });

  @override
  Future<String?> getActiveSpaceSlug() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(activeSpaceKey);
  }

  @override
  Future<void> setActiveSpaceSlug(String? slug) async {
    final prefs = await SharedPreferences.getInstance();
    if (slug == null) {
      await prefs.remove(activeSpaceKey);
    } else {
      await prefs.setString(activeSpaceKey, slug);
    }
  }
}

