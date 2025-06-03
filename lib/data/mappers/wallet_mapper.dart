import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';

class WalletMapper {
  static WalletEntity toDomain(Wallet row) {
    return WalletEntity(
      clientId: row.clientId,
      name: row.name,
      type: row.type,
      balance: row.balance,
      currencyCode: row.currency,
      description: row.description,
      createdAt: row.createdAt,
      id: row.id,
      userId: row.userId,
      updatedAt: row.updatedAt,
      stats: row.stats,
    );
  }

  static List<WalletEntity> toDomainList(List<Wallet> rows) {
    return rows.map((row) => toDomain(row)).toList();
  }
}
