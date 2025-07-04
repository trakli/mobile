import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart' as db;
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/datasources/category/category_local_datasource.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/repositories/category_repository.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:trakli/data/sync/category_sync_handler.dart';
import 'package:trakli/data/mappers/category_mapper.dart';
import 'package:trakli/data/models/media.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl
    extends SyncEntityRepository<db.AppDatabase, db.Category, String, int>
    implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required CategorySyncHandler syncHandler,
    required this.localDataSource,
    required super.db,
  }) : super(syncHandler: syncHandler);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categories = await localDataSource.getAllCategories();
      return Right(CategoryMapper.toDomainList(categories));
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> insertCategory(
      String name, String slug, TransactionType type, int userId,
      {String? description, MediaEntity? media}) async {
    try {
      final category = await localDataSource.insertCategory(
        name,
        slug,
        type,
        userId,
        description: description,
        media: media != null
            ? Media.fromLocal(content: media.content, type: media.mediaType)
            : null,
      );

      unawaited(post(category));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateCategory(
    String clientId, {
    String? name,
    String? slug,
    String? description,
    MediaEntity? media,
  }) async {
    try {
      final category = await localDataSource.updateCategory(
        clientId,
        name: name,
        slug: slug,
        description: description,
        media: media != null
            ? Media.fromLocal(content: media.content, type: media.mediaType)
            : null,
      );
      unawaited(put(category));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String clientId) async {
    try {
      final category = await localDataSource.deleteCategory(clientId);
      unawaited(delete(category));
      return const Right(unit);
    } catch (e) {
      return Left(Failure.cacheError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<CategoryEntity>>> listenToCategories() {
    return localDataSource.listenToCategories().map((categories) {
      return Right(CategoryMapper.toDomainList(categories));
    });
  }
}
