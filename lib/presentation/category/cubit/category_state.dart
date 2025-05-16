part of 'category_cubit.dart';

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
        failure: Failure.none(),
      );
}
