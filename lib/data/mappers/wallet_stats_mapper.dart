import 'package:trakli/data/models/wallet_stats.dart';
import 'package:trakli/domain/entities/wallet_stats_entity.dart';

class WalletStatsMapper {
  static WalletStatsEntity toDomain(WalletStats stats) {
    return WalletStatsEntity(
      totalIncome: stats.totalIncome,
      totalExpense: stats.totalExpense,
    );
  }

  static WalletStats toData(WalletStatsEntity entity) {
    return WalletStats(
      totalIncome: entity.totalIncome,
      totalExpense: entity.totalExpense,
    );
  }

  static WalletStatsEntity? toDomainNullable(WalletStats? stats) {
    if (stats == null) return null;
    return toDomain(stats);
  }

  static WalletStats? toDataNullable(WalletStatsEntity? entity) {
    if (entity == null) return null;
    return toData(entity);
  }
}
