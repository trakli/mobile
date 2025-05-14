import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_response_dto.freezed.dart';
part 'create_user_response_dto.g.dart';

@freezed
class CreateUserResponseDto with _$CreateUserResponseDto {
  const factory CreateUserResponseDto({
    @JsonKey(name: 'token') required String accessToken,
    @JsonKey(name: 'user') required Map<String, dynamic> user,
  }) = _CreateUserResponseDto;

  factory CreateUserResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseDtoFromJson(json);
}
