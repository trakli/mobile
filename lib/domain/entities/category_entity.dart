import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/dto/sync_state_dto.dart';

part 'category_entity.freezed.dart';
part 'category_entity.g.dart';

@freezed
class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    @JsonKey(name: 'client_generated_id') String? clientGeneratedId,
    required TransactionType type,
    required String name,
    String? description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    int? id,
    String? slug,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'last_synced_at') String? lastSyncedAt,
    @JsonKey(name: 'sync_state') SyncStateDto? syncState,
  }) = _CategoryEntity;

  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      _$CategoryEntityFromJson(json);
}
