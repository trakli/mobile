import 'package:trakli/data/database/app_database.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/data/mappers/wallet_stats_mapper.dart';

class WalletMapper {
  static WalletEntity toDomain(Wallet wallet) {
    return WalletEntity(
      clientId: wallet.clientId,
      type: wallet.type,
      name: wallet.name,
      description: wallet.description,
      balance: wallet.balance,
      currencyCode: wallet.currency,
      createdAt: wallet.createdAt,
      id: wallet.id,
      userId: wallet.userId,
      updatedAt: wallet.updatedAt,
      stats: WalletStatsMapper.toDomainNullable(wallet.stats),
    );
  }

  static List<WalletEntity> toDomainList(List<Wallet> wallets) {
    return wallets.map((wallet) => toDomain(wallet)).toList();
  }
}
