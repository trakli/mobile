import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:trakli/data/datasources/core/dto/sync_state_dto.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/data/models/media.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@freezed
class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    @JsonKey(name: 'client_generated_id') required String clientId,
    required TransactionType type,
    required String name,
    String? description,
    @JsonKey(name: 'created_at', fromJson: DateTime.parse)
    required DateTime createdAt,
    int? id,
    required String slug,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'updated_at', fromJson: DateTime.parse)
    required DateTime updatedAt,
    @JsonKey(name: 'last_synced_at', fromJson: DateTime.parse)
    DateTime? lastSyncedAt,
    @JsonKey(name: 'sync_state') required SyncStateDto syncState,
    Media? media,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}
