import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'transaction_entity.freezed.dart';
part 'transaction_entity.g.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String clientId,
    required double amount,
    required String description,
    // required String category,
    // required DateTime createdAtLocal,
    // required DateTime updatedAtLocal,
    required DateTime createdAt,
    required DateTime updatedAt,
    // required DateTime updatedAt,
    required DateTime datetime,
    required TransactionType type,
    // DateTime? updatedAtServer,
    // DateTime? deletedAtServer,
    DateTime? lastSyncedAt,
    @Default('1') String rev,
  }) = _TransactionEntity;

  factory TransactionEntity.fromJson(Map<String, dynamic> json) =>
      _$TransactionEntityFromJson(json);
}
