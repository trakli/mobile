import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/database/tables/enums.dart';
import 'package:trakli/data/datasources/core/dto/sync_state_dto.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

@freezed
class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    @JsonKey(name: 'client_generated_id') required String clientId,
    required CategoryType type,
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
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  // Convert to local Data for drift
  // factory Category toLocal() {
  //   return Category(
  //     id: id,
  //     name: name,
  //     description: description,
  //     clientId: clientId,
  //     type: type,
  //     createdAt: createdAt,
  //     updatedAt: updatedAt,
  //     lastSyncedAt: lastSyncedAt,
  //     // syncState: syncState,
  //     slug: slug,
  //     userId: userId,
  //   );
  // }
}
