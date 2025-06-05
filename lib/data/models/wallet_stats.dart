import 'package:json_annotation/json_annotation.dart';

part 'wallet_stats.g.dart';

@JsonSerializable()
class WalletStats {
  @JsonKey(name: 'total_income')
  final double totalIncome;

  @JsonKey(name: 'total_expense')
  final double totalExpense;

  WalletStats({
    required this.totalIncome,
    required this.totalExpense,
  });

  factory WalletStats.fromJson(Map<String, dynamic> json) =>
      _$WalletStatsFromJson(json);

  Map<String, dynamic> toJson() => _$WalletStatsToJson(this);
}
