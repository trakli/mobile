import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory PaginationResponse.empty() => PaginationResponse<T>(
        currentPage: -1,
        lastPage: -1,
        perPage: -1,
        data: [],
      );

  bool get hasMore => currentPage < lastPage;
}
