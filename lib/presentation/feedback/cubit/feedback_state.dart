part of 'feedback_cubit.dart';

@freezed
class FeedbackState with _$FeedbackState {
  const factory FeedbackState({
    required List<FeedbackEntity> items,
    required bool isLoading,
    required bool isSubmitting,

    /// Why the history could not be loaded; shown in place of the list.
    required Failure loadFailure,

    /// Why the last submission failed; surfaced as a snackbar.
    required Failure failure,

    /// Bumped on every successful submission so listeners can react to each
    /// one, even when two sends carry the same text.
    required int submittedCount,
  }) = _FeedbackState;

  factory FeedbackState.initial() => const FeedbackState(
        items: [],
        isLoading: false,
        isSubmitting: false,
        loadFailure: Failure.none(),
        failure: Failure.none(),
        submittedCount: 0,
      );
}
