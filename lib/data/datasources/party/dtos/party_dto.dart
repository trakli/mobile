import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/models/media.dart';
import 'package:trakli/domain/entities/party_entity.dart';

part 'party_dto.freezed.dart';
part 'party_dto.g.dart';

@freezed
class PartyDto with _$PartyDto {
  const factory PartyDto({
    required int id,
    required String name,
    String? description,
    @JsonKey() required PartyType type,
    @JsonKey(name: 'client_generated_id') required String clientId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    required int userId,
    Media? media,
  }) = _PartyDto;

  factory PartyDto.fromJson(Map<String, dynamic> json) =>
      _$PartyDtoFromJson(json);

  const PartyDto._();
}
