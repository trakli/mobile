import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    required int statusCode,
    required String message,
    required dynamic data,
    required bool success,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  factory ApiResponse.getResponse(String data) {
    final dataJson = json.decode(data) as Map<String, dynamic>;
    return ApiResponse.fromJson(dataJson);
  }
}
