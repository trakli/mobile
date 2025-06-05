import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:trakli/data/models/wallet_stats.dart';

class WalletStatsConverter extends TypeConverter<WalletStats, String>
    with JsonTypeConverter2<WalletStats, String, Map<String, Object?>> {
  const WalletStatsConverter();

  @override
  WalletStats fromSql(String fromDb) {
    final json = jsonDecode(fromDb) as Map<String, dynamic>;
    return WalletStats.fromJson(json);
  }

  @override
  String toSql(WalletStats value) {
    return jsonEncode(value.toJson());
  }

  @override
  WalletStats fromJson(Map<String, Object?> json) {
    return WalletStats.fromJson(json);
  }

  @override
  Map<String, Object?> toJson(WalletStats value) {
    return value.toJson();
  }
}
