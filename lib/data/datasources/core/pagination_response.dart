import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/sync/sync_entity.dart';
import 'package:trakli/core/utils/services/logger.dart';

part 'pagination_response.freezed.dart';
part 'pagination_response.g.dart';

@Freezed(genericArgumentFactories: true)
class PaginationResponse<T> with _$PaginationResponse<T> {
  factory PaginationResponse({
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
    required List<T> data,
  }) = _PaginationResponse;

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginationResponseFromJson(json, fromJsonT);

  PaginationResponse._();

  /// Like [fromJson], but drops rows [fromJsonT] cannot read instead of
  /// failing the whole page.
  ///
  /// Down-sync catches parse errors per entity type, not per row, so one
  /// unreadable row used to fail every row of that type on every sync cycle —
  /// indefinitely, since the row never changes. (A null `datetime` on
  /// pre-February transfers did exactly that.) Skipping costs the one row
  /// until the data is fixed; failing the page costs all of them, forever.
  factory PaginationResponse.lenient(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT, {
    required SyncEntity entityType,
  }) {
    final rows = json['data'] as List<dynamic>? ?? const [];
    final parsed = <T>[];

    for (final row in rows) {
      try {
        parsed.add(fromJsonT(row));
      } catch (e, stackTrace) {
        final clientId = row is Map<String, dynamic>
            ? row['client_generated_id'] ?? row['id']
            : null;
        logger.w(
          'Skipped an unreadable ${entityType.key} row ($clientId) while syncing',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    // Casting the envelope would throw past the row-level recovery above and
    // lose the whole page anyway. -1 matches PaginationResponse.empty() and
    // leaves hasMore false, so a malformed envelope degrades to "keep what
    // parsed, fetch nothing further" rather than looping or failing.
    return PaginationResponse<T>(
      currentPage: (json['current_page'] as num?)?.toInt() ?? -1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? -1,
      perPage: (json['per_page'] as num?)?.toInt() ?? -1,
      data: parsed,
    );
  }

  factory PaginationResponse.empty() => PaginationResponse<T>(
        currentPage: -1,
        lastPage: -1,
        perPage: -1,
        data: [],
      );

  bool get hasMore => currentPage < lastPage;
}
