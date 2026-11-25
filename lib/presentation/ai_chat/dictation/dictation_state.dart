part of 'dictation_cubit.dart';

enum DictationStatus { idle, starting, listening }

enum DictationError { none, permissionDenied, unavailable, failed }

@freezed
class DictationState with _$DictationState {
  const factory DictationState({
    @Default(DictationStatus.idle) DictationStatus status,
    @Default(true) bool isAvailable,
    @Default('') String recognizedWords,
    @Default(DictationError.none) DictationError error,
  }) = _DictationState;

  const DictationState._();

  factory DictationState.initial() => const DictationState();

  bool get isListening => status == DictationStatus.listening;
  bool get isActive => status != DictationStatus.idle;
}
