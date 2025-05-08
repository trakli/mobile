import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/category_entity.dart';

part 'category_state.freezed.dart';

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState({
    required List<CategoryEntity> categories,
    required bool isLoading,
    required bool isSaving,
    required bool isDeleting,
    required Failure failure,
  }) = _CategoryState;

  factory CategoryState.initial() => const CategoryState(
        categories: [],
        isLoading: false,
        isSaving: false,
        isDeleting: false,
        failure: const Failure.none(),
      );
}
