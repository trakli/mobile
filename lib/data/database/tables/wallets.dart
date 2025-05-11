import 'package:drift/drift.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/database/tables/sync_table.dart';

@DataClassName('Wallet')
class Wallets extends Table with SyncTable {
  TextColumn get name => text()();
  TextColumn get type => textEnum<WalletType>()();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get description => text().nullable()();
  IntColumn get userId => integer()();
}
