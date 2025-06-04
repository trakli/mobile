import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';

part 'category_entity.freezed.dart';

@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String clientId,
    required TransactionType type,
    required String name,
    String? description,
    required DateTime createdAt,
    int? id,
    String? slug,
    int? userId,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
  }) = _CategoryEntity;
}
