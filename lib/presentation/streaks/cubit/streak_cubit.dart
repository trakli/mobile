import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/streak_entity.dart';
import 'package:trakli/domain/usecases/streak/get_streaks_usecase.dart';

part 'streak_state.dart';
part 'streak_cubit.freezed.dart';

/// The user's streaks as the server counts them. Online-only: a failed
/// refresh keeps the streaks already shown rather than clearing them.
@injectable
class StreakCubit extends Cubit<StreakState> {
  final GetStreaksUseCase _getStreaks;

  StreakCubit(this._getStreaks) : super(StreakState.initial());

  Future<void> loadStreaks() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, failure: const Failure.none()));

    final result = await _getStreaks(NoParams());

    // The chip that owns this cubit goes away on sign-out, which can land
    // while the request is still out.
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, failure: failure)),
      (streaks) => emit(state.copyWith(isLoading: false, streaks: streaks)),
    );
  }
}
