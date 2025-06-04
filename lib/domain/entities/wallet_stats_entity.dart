import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_stats_entity.freezed.dart';

@freezed
class WalletStatsEntity with _$WalletStatsEntity {
  const factory WalletStatsEntity({
    required double totalIncome,
    required double totalExpense,
  }) = _WalletStatsEntity;
}
