import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/usecases/category/add_category_usecase.dart';
import 'package:trakli/domain/usecases/category/delete_category_usecase.dart';
import 'package:trakli/domain/usecases/category/get_categories_usecase.dart';
import 'package:trakli/domain/usecases/category/update_category_usecase.dart';

part 'category_state.dart';
part 'category_cubit.freezed.dart';

@injectable
class CategoryCubit extends Cubit<CategoryState> {
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryCubit(
    this._addCategoryUseCase,
    this._updateCategoryUseCase,
    this._deleteCategoryUseCase,
    this._getCategoriesUseCase,
  ) : super(CategoryState.initial()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, failure: const Failure.none()));
    final result = await _getCategoriesUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        failure: failure,
      )),
      (categories) => emit(state.copyWith(
        isLoading: false,
        categories: categories,
        failure: const Failure.none(),
      )),
    );
  }

  Future<void> addCategory({
    required String name,
    required String slug,
    required TransactionType type,
    required int userId,
    String? description,
    MediaEntity? media,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _addCategoryUseCase(
      AddCategoryUseCaseParams(
        name: name,
        slug: slug,
        type: type,
        userId: userId,
        description: description,
        media: media,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) {
        emit(state.copyWith(
          isSaving: false,
          failure: const Failure.none(),
        ));

        loadCategories();
      },
    );
  }

  Future<void> updateCategory({
    required String clientId,
    String? name,
    String? slug,
    int? userId,
    String? description,
    MediaEntity? media,
  }) async {
    emit(state.copyWith(isSaving: true, failure: const Failure.none()));
    final result = await _updateCategoryUseCase(
      UpdateCategoryUseCaseParams(
        clientId: clientId,
        name: name,
        slug: slug,
        userId: userId,
        description: description,
        media: media,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isSaving: false,
        failure: failure,
      )),
      (_) {
        emit(state.copyWith(
          isSaving: false,
          failure: const Failure.none(),
        ));

        loadCategories();
      },
    );
  }

  Future<void> deleteCategory(String clientId) async {
    emit(state.copyWith(isDeleting: true, failure: const Failure.none()));

    // Optimistically update the UI
    final updatedCategories = state.categories
        .where((category) => category.clientId != clientId)
        .toList();

    emit(state.copyWith(
      categories: updatedCategories,
      isDeleting: true,
    ));

    final result = await _deleteCategoryUseCase(clientId);
    result.fold(
      (failure) => emit(state.copyWith(
        isDeleting: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isDeleting: false,
        failure: const Failure.none(),
      )),
    );
  }
}
