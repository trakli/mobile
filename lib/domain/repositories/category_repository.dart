import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'dart:async';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();

  Future<Either<Failure, Unit>> insertCategory(
    String name,
    String slug,
    TransactionType type, {
    String? description,
    MediaEntity? media,
  });

  Future<Either<Failure, Unit>> updateCategory(
    String clientId, {
    String? name,
    String? slug,
    String? description,
    MediaEntity? media,
  });

  Future<Either<Failure, Unit>> deleteCategory(String clientId);

  Stream<Either<Failure, List<CategoryEntity>>> listenToCategories();
}
