import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'dart:async';

abstract class PartyRepository {
  Future<Either<Failure, List<PartyEntity>>> getAllParties();

  Future<Either<Failure, Unit>> insertParty(
    String name, {
    String? description,
    MediaEntity? media,
  });

  Future<Either<Failure, Unit>> updateParty(
    String clientId, {
    String? name,
    String? description,
    MediaEntity? media,
  });

  Future<Either<Failure, Unit>> deleteParty(String clientId);

  Stream<Either<Failure, List<PartyEntity>>> listenToParties();
}
