import 'package:drift/drift.dart';
import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/date_util.dart';
import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/core/utils/id_helper.dart';
import 'package:trakli/core/error/exceptions.dart';

abstract class WalletLocalDataSource {
  Future<List<Wallet>> getAllWallets();
  Future<Wallet?> getWallet(String clientId);
  Future<Wallet> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
    Media? icon,
  });
  Future<Wallet> updateWallet(
    String clientId, {
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? description,
    Media? icon,
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

  /// The same name and currency is the same wallet, case and surrounding
  /// spaces aside.
  Future<Wallet?> _findByServerIdentity(
    String name,
    String currency, {
    String? excluding,
  }) {
    final normalizedName = name.trim().toLowerCase();
    final normalizedCurrency = currency.trim().toLowerCase();
    return (database.select(database.wallets)
          ..where((w) {
            final matches = w.name.trim().lower().equals(normalizedName) &
                w.currency.trim().lower().equals(normalizedCurrency);
            return excluding == null
                ? matches
                : matches & w.clientId.isNotValue(excluding);
          })
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<Wallet> insertWallet(
    String name,
    WalletType type,
    double balance,
    String currency, {
    String? description,
    Media? icon,
  }) async {
    final existing = await _findByServerIdentity(name, currency);
    if (existing != null) {
      throw DuplicateException('Wallet "$name" in $currency already exists');
    }

    DateTime dateTime = getNewFormattedUtcDateTime();

    final companion = WalletsCompanion.insert(
      clientId: Value(
        await generateDeviceScopedId(),
      ),
      name: name.trim(),
      type: type,
      balance: Value(balance),
      currency: currency,
      description: Value(description),
      createdAt: Value(dateTime),
      updatedAt: Value(dateTime),
      icon: Value(icon),
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
    Media? icon,
  }) async {
    // Name and currency identify a wallet together, so check the pair the
    // row will hold afterwards, not just the field being changed.
    if (name != null || currency != null) {
      final current = await getWallet(clientId);
      if (current != null) {
        final effectiveName = name ?? current.name;
        final effectiveCurrency = currency ?? current.currency;
        final existing = await _findByServerIdentity(
          effectiveName,
          effectiveCurrency,
          excluding: clientId,
        );
        if (existing != null) {
          throw DuplicateException(
            'Wallet "$effectiveName" in $effectiveCurrency already exists',
          );
        }
      }
    }

    DateTime dateTime = getNewFormattedUtcDateTime();

    final companion = WalletsCompanion(
      name: name != null ? Value(name.trim()) : const Value.absent(),
      type: type != null ? Value(type) : const Value.absent(),
      balance: balance != null ? Value(balance) : const Value.absent(),
      currency: currency != null ? Value(currency) : const Value.absent(),
      description:
          description != null ? Value(description) : const Value.absent(),
      updatedAt: Value(dateTime),
      icon: icon != null ? Value(icon) : const Value.absent(),
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
          ..orderBy([(w) => OrderingTerm.asc(w.createdAt)]))
        .watch();
  }

  Future<Transaction?> _getTransactionsByWalletClientId(String clientId) {
    return (database.select(database.transactions)
          ..where((t) => t.walletClientId.equals(clientId)))
        .getSingleOrNull();
  }
}
