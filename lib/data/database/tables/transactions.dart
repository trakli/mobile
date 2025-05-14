import 'package:drift/drift.dart';
import 'package:trakli/data/database/tables/groups.dart';
import 'package:trakli/data/database/tables/parties.dart';
import 'package:trakli/data/database/tables/sync_table.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/database/tables/wallets.dart';

@DataClassName('Transaction')
class Transactions extends Table with SyncTable {
  // Note: id and clientId are inherited from SyncTable
  // id is for server, clientId is for local

  @JsonKey('amount')
  RealColumn get amount => real()();

  @JsonKey('type')
  TextColumn get type => textEnum<TransactionType>()();

  @JsonKey('description')
  TextColumn get description => text().nullable()();

  @JsonKey('datetime')
  DateTimeColumn get datetime => dateTime()();

  // Server references
  @JsonKey('party_id')
  IntColumn get partyId => integer().nullable()();

  @JsonKey('wallet_id')
  IntColumn get walletId => integer().nullable()();

  @JsonKey('group_id')
  IntColumn get groupId => integer().nullable()();

  // Local references
  TextColumn get walletClientId =>
      text().references(Wallets, #clientId).nullable()();
  TextColumn get partyClientId =>
      text().references(Parties, #clientId).nullable()();
  TextColumn get groupClientId =>
      text().references(Groups, #clientId).nullable()();
}
