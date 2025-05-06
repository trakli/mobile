import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_state_dto.freezed.dart';
part 'sync_state_dto.g.dart';

@freezed
class SyncStateDto with _$SyncStateDto {
  const factory SyncStateDto({
    required int id,
    @JsonKey(name: 'syncable_type') required String syncableType,
    @JsonKey(name: 'syncable_id') required int syncableId,
    String? source,
    @JsonKey(name: 'client_generated_id') required String clientGeneratedId,
    @JsonKey(name: 'last_synced_at') required String lastSyncedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _SyncStateDto;

  factory SyncStateDto.fromJson(Map<String, dynamic> json) =>
      _$SyncStateDtoFromJson(json);
}
