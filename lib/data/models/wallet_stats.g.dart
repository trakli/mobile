// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletStats _$WalletStatsFromJson(Map<String, dynamic> json) => WalletStats(
      totalIncome: (json['total_income'] as num).toDouble(),
      totalExpense: (json['total_expense'] as num).toDouble(),
    );

Map<String, dynamic> _$WalletStatsToJson(WalletStats instance) =>
    <String, dynamic>{
      'total_income': instance.totalIncome,
      'total_expense': instance.totalExpense,
    };
