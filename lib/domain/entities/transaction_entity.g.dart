// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntityImpl _$$TransactionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionEntityImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      createdAtLocal: DateTime.parse(json['createdAtLocal'] as String),
      updatedAtLocal: DateTime.parse(json['updatedAtLocal'] as String),
      updatedAtServer: json['updatedAtServer'] == null
          ? null
          : DateTime.parse(json['updatedAtServer'] as String),
      deletedAtServer: json['deletedAtServer'] == null
          ? null
          : DateTime.parse(json['deletedAtServer'] as String),
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      rev: json['rev'] as String? ?? '1',
    );

Map<String, dynamic> _$$TransactionEntityImplToJson(
        _$TransactionEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'description': instance.description,
      'category': instance.category,
      'createdAtLocal': instance.createdAtLocal.toIso8601String(),
      'updatedAtLocal': instance.updatedAtLocal.toIso8601String(),
      'updatedAtServer': instance.updatedAtServer?.toIso8601String(),
      'deletedAtServer': instance.deletedAtServer?.toIso8601String(),
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'rev': instance.rev,
    };
