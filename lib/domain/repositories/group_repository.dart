import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'dart:async';

abstract class GroupRepository {
  Future<Either<Failure, List<GroupEntity>>> getAllGroups();

  Future<Either<Failure, Unit>> insertGroup({
    required String name,
    String? description,
    MediaEntity? icon,
  });

  Future<Either<Failure, Unit>> updateGroup(
    String clientId, {
    String? name,
    String? description,
    MediaEntity? icon,
  });

  Future<Either<Failure, Unit>> deleteGroup(String clientId);

  Stream<Either<Failure, List<GroupEntity>>> listenToGroups();
}
