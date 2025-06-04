import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:uuid/uuid.dart';

abstract class WalletLocalDataSource {
  Future<List<Wallet>> getAllWallets();
  Future<Wallet?> getWallet(String clientId);
  Future<Wallet> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
  });
  Future<Wallet> updateWallet(
    String clientId, {
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
  });
  Future<void> deleteWallet(String clientId);
  Future<void> deleteAllWallets();
  Stream<List<Wallet>> listenToWallets();
}

@Injectable(as: WalletLocalDataSource)
class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  final AppDatabase database;

  WalletLocalDataSourceImpl({
    required this.database,
  });

  @override
  Future<List<Wallet>> getAllWallets() async {
    return await database.select(database.wallets).get();
  }

  @override
  Future<Wallet?> getWallet(String clientId) async {
    final query = database.select(database.wallets)
      ..where((tbl) => tbl.clientId.equals(clientId));
    return await query.getSingleOrNull();
  }

  @override
  Future<Wallet> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
  }) async {
    final now = DateTime.now();
    DateTime dateTime = formatServerIsoDateTime(now);

    final companion = WalletsCompanion.insert(
      clientId: const Uuid().v4(),
      name: name,
      type: type,
      balance: Value(balance),
      currency: currency,
      description: Value(description),
      createdAt: Value(dateTime),
      updatedAt: Value(dateTime),
    );

    final model =
        await database.into(database.wallets).insertReturning(companion);
    return model;
  }

  @override
  Future<Wallet> updateWallet(
    String clientId, {
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
  }) async {
    final now = DateTime.now();
    DateTime dateTime = formatServerIsoDateTime(now);

    final companion = WalletsCompanion(
      name: name != null ? Value(name) : const Value.absent(),
      type: type != null ? Value(type) : const Value.absent(),
      balance: balance != null ? Value(balance) : const Value.absent(),
      currency: currency != null ? Value(currency) : const Value.absent(),
      description:
          description != null ? Value(description) : const Value.absent(),
      updatedAt: Value(dateTime),
    );

    final model = await (database.update(database.wallets)
          ..where((tbl) => tbl.clientId.equals(clientId)))
        .writeReturning(companion);

    return model.first;
  }

  @override
  Future<void> deleteWallet(String clientId) async {
    final transaction = await _getTransactionsByWalletClientId(clientId);
    if (transaction != null) {
      throw const ConflictException(
        message: 'Cannot delete wallet that has transactions',
      );
    }

    await (database.delete(database.wallets)
          ..where((tbl) => tbl.clientId.equals(clientId)))
        .go();
  }

  @override
  Future<void> deleteAllWallets() async {
    await database.delete(database.wallets).go();
  }

  @override
  Stream<List<Wallet>> listenToWallets() {
    return (database.select(database.wallets)
          ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]))
        .watch();
  }

  Future<Transaction?> _getTransactionsByWalletClientId(String clientId) {
    return (database.select(database.transactions)
          ..where((t) => t.walletClientId.equals(clientId)))
        .getSingleOrNull();
  }
}
