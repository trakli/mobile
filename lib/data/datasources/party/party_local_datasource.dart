import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:trakli/data/models/media.dart';

abstract class PartyLocalDataSource {
  Future<List<Party>> getAllParties();
  Future<Party?> getParty(String clientId);
  Future<Party> insertParty(
    String name, {
    String? description,
    Media? media,
  });
  Future<Party> updateParty(
    String clientId, {
    String? name,
    String? description,
    Media? media,
  });
  Future<Party> deleteParty(String clientId);
  Future<void> deleteAllParties();
  Stream<List<Party>> listenToParties();
}

@Injectable(as: PartyLocalDataSource)
class PartyLocalDataSourceImpl implements PartyLocalDataSource {
  final AppDatabase database;

  PartyLocalDataSourceImpl(this.database);

  @override
  Future<List<Party>> getAllParties() async {
    return await (database.select(database.parties)).get();
  }

  @override
  Future<Party?> getParty(String clientId) async {
    return await (database.select(database.parties)
          ..where((p) => p.clientId.equals(clientId)))
        .getSingleOrNull();
  }

  @override
  Future<Party> insertParty(
    String name, {
    String? description,
    Media? media,
  }) async {
    final now = formatServerIsoDateTime(DateTime.now());

    final model = await database.into(database.parties).insertReturning(
          PartiesCompanion.insert(
            clientId: const Uuid().v4(),
            name: name,
            description: Value(description),
            createdAt: Value(now),
            updatedAt: Value(now),
            media: Value(media),
          ),
        );

    return model;
  }

  @override
  Future<Party> updateParty(
    String clientId, {
    String? name,
    String? description,
    Media? media,
  }) async {
    final now = formatServerIsoDateTime(DateTime.now());

    final party = await (database.update(database.parties)
          ..where((p) => p.clientId.equals(clientId)))
        .writeReturning(
      PartiesCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
        updatedAt: Value(now),
        media: media != null ? Value(media) : const Value.absent(),
      ),
    );

    return party.first;
  }

  @override
  Future<Party> deleteParty(String clientId) async {
    final party = await (database.select(database.parties)
          ..where((p) => p.clientId.equals(clientId)))
        .getSingle();

    await (database.delete(database.parties)
          ..where((p) => p.clientId.equals(clientId)))
        .go();

    return party;
  }

  @override
  Future<void> deleteAllParties() async {
    await database.delete(database.parties).go();
  }

  @override
  Stream<List<Party>> listenToParties() {
    return (database.select(database.parties)
          ..orderBy([(p) => OrderingTerm.desc(p.createdAt)]))
        .watch();
  }
}
