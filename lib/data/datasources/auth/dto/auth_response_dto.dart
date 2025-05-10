import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

@freezed
class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    @JsonKey(name: 'token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'expires_in') int? expireTn,
    @JsonKey(name: 'token_type') String? tokenType,
    @JsonKey(name: 'user') required Map<String, dynamic> user,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
}
