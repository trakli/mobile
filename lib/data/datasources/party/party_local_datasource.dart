import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/core/error/exceptions.dart';
import 'package:trakli/domain/entities/party_entity.dart';

abstract class PartyLocalDataSource {
  Future<List<Party>> getAllParties();
  Future<Party?> getParty(String clientId);
  Future<Party> insertParty(
    String name, {
    String? description,
    Media? media,
    PartyType? type,
  });
  Future<Party> updateParty(
    String clientId, {
    String? name,
    String? description,
    Media? media,
    PartyType? type,
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

  /// The same name is the same party, whatever its type, case and
  /// surrounding spaces aside.
  Future<Party?> _findByServerName(String name, {String? excluding}) {
    final normalized = name.trim().toLowerCase();
    return (database.select(database.parties)
          ..where((p) {
            final matches = p.name.trim().lower().equals(normalized);
            return excluding == null
                ? matches
                : matches & p.clientId.isNotValue(excluding);
          })
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<Party> insertParty(
    String name, {
    String? description,
    Media? media,
    PartyType? type,
  }) async {
    final existing = await _findByServerName(name);
    if (existing != null) {
      throw DuplicateException('Party with name "$name" already exists');
    }

    final now = getNewFormattedUtcDateTime();

    final model = await database.into(database.parties).insertReturning(
          PartiesCompanion.insert(
            clientId: Value(await generateDeviceScopedId()),
            name: name.trim(),
            description: Value(description),
            createdAt: Value(now),
            updatedAt: Value(now),
            icon: Value(media),
            type: Value(type),
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
    PartyType? type,
  }) async {
    if (name != null) {
      final existing = await _findByServerName(name, excluding: clientId);
      if (existing != null) {
        throw DuplicateException('Party with name "$name" already exists');
      }
    }

    final now = getNewFormattedUtcDateTime();

    final party = await (database.update(database.parties)
          ..where((p) => p.clientId.equals(clientId)))
        .writeReturning(
      PartiesCompanion(
        name: name != null ? Value(name.trim()) : const Value.absent(),
        description:
            description != null ? Value(description) : const Value.absent(),
        updatedAt: Value(now),
        icon: media != null ? Value(media) : const Value.absent(),
        type: type != null ? Value(type) : const Value.absent(),
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
