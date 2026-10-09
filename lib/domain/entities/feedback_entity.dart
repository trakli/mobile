import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_entity.freezed.dart';

/// What a piece of feedback is about. [serverKey] is the value the API takes.
enum FeedbackType {
  general('general'),
  bug('bug'),
  feature('feature'),
  question('question');

  const FeedbackType(this.serverKey);

  final String serverKey;

  static FeedbackType fromServerKey(String? key) => FeedbackType.values
      .firstWhere((type) => type.serverKey == key, orElse: () => general);
}

/// A message the user sent to the team, with the triage status the team has
/// given it (new, triaged, planned, in_progress, resolved, archived).
@freezed
class FeedbackEntity with _$FeedbackEntity {
  const factory FeedbackEntity({
    required int id,
    required FeedbackType type,
    required String status,
    String? subject,
    required String message,
    DateTime? createdAt,
  }) = _FeedbackEntity;
}
