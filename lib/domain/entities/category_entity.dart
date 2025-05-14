import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/dto/sync_state_dto.dart';

part 'category_entity.freezed.dart';
// part 'category_entity.g.dart';

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
    String? lastSyncedAt,
    SyncStateDto? syncState,
  }) = _CategoryEntity;

  // factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
  //     _$CategoryEntityFromJson(json);
}
