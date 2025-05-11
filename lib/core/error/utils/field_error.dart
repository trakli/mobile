import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/utils/services/logger.dart';

part 'field_error.freezed.dart';
part 'field_error.g.dart';

@freezed
class FieldError with _$FieldError {
  const factory FieldError({
    required String field,
    required List<String> messages,
  }) = _FieldError;

  const FieldError._();

  factory FieldError.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorFromJson(json);

  static List<FieldError> getErrors(dynamic data) {
    // ignore: avoid_dynamic_calls
    // final dataErrors = jsonDecode(data.toString());
    // ignore: avoid_dynamic_calls
    final errors = data['errors'];

    logger.e(data);

    if (errors is Map) {
      try {
        final results =
            Map<String, dynamic>.from(errors as Map<String, dynamic>);

        return results.entries
            .map(
              (e) => FieldError(
                field: e.key,
                messages: List<String>.from(e.value as List<dynamic>),
              ),
            )
            .toList();
      } catch (e) {
        logger.e(e);
      }
    }

    if (errors is List) {
      final errorsList = List<Map<String, dynamic>>.from(errors);

      return errorsList
          .expand((e) => e.entries.map(
                (e) => FieldError(
                  field: e.key,
                  messages: List<String>.from(e.value as List<dynamic>),
                ),
              ))
          .toList();
    }

    // ignore: avoid_dynamic_calls
    if (data['message'] != null) {
      return [
        FieldError(
          field: 'message',
          // ignore: avoid_dynamic_calls
          messages: [data['message'] as String],
        ),
      ];
    }

    return [];
  }
}
