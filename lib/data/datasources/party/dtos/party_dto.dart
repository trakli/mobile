import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/data/database/app_database.dart';
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
    required int userId,
    Media? media,
  }) = _PartyDto;

  factory PartyDto.fromJson(Map<String, dynamic> json) =>
      _$PartyDtoFromJson(json);

  const PartyDto._();

  Party toModel() {
    return Party(
      id: id,
      name: name,
      type: type,
      description: description,
      clientId: clientId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
      icon: media,
    );
  }
}
