import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/core/usecases/usecase.dart';
import 'package:trakli/domain/entities/feedback_entity.dart';
import 'package:trakli/domain/usecases/feedback/get_feedback_usecase.dart';
import 'package:trakli/domain/usecases/feedback/submit_feedback_usecase.dart';

part 'feedback_state.dart';
part 'feedback_cubit.freezed.dart';

/// Sends feedback to the team and lists what the user has sent before.
/// Feedback is online-only: there is no local copy to fall back on.
@injectable
class FeedbackCubit extends Cubit<FeedbackState> {
  final GetFeedbackUseCase _getFeedback;
  final SubmitFeedbackUseCase _submitFeedback;

  FeedbackCubit(this._getFeedback, this._submitFeedback)
      : super(FeedbackState.initial());

  Future<void> loadFeedback() async {
    emit(state.copyWith(
      isLoading: true,
      loadFailure: const Failure.none(),
    ));

    final result = await _getFeedback(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, loadFailure: failure)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  Future<void> submitFeedback({
    required FeedbackType type,
    String? subject,
    required String message,
  }) async {
    if (state.isSubmitting) return;

    emit(state.copyWith(
      isSubmitting: true,
      failure: const Failure.none(),
    ));

    final trimmedSubject = subject?.trim();
    final result = await _submitFeedback(SubmitFeedbackUseCaseParams(
      type: type,
      subject: trimmedSubject == null || trimmedSubject.isEmpty
          ? null
          : trimmedSubject,
      message: message.trim(),
    ));

    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
      (item) => emit(state.copyWith(
        isSubmitting: false,
        items: [item, ...state.items],
        submittedCount: state.submittedCount + 1,
      )),
    );
  }
}
