import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/domain/entities/config_entity.dart';

part 'config_dto.freezed.dart';
part 'config_dto.g.dart';

@freezed
class ConfigDto with _$ConfigDto {
  const factory ConfigDto({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String key,
    required dynamic value,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ConfigDto;

  factory ConfigDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigDtoFromJson(json);

  const ConfigDto._();

  ConfigEntity toEntity() => ConfigEntity(
        id: id,
        userId: userId,
        key: key,
        value: value,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
