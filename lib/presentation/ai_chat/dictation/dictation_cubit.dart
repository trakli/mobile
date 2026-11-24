import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/services/speech_recognition_service.dart';

part 'dictation_cubit.freezed.dart';
part 'dictation_state.dart';

@injectable
class DictationCubit extends Cubit<DictationState> {
  final SpeechRecognitionService _speech;

  bool _initialized = false;
  int _session = 0;

  DictationCubit(this._speech) : super(DictationState.initial());

  Future<void> toggle({String? languageCode}) async {
    if (state.isActive) {
      await stop();
    } else {
      await start(languageCode: languageCode);
    }
  }

  Future<void> start({String? languageCode}) async {
    if (state.isActive || !state.isAvailable) return;
    final session = ++_session;
    emit(state.copyWith(
      status: DictationStatus.starting,
      recognizedWords: '',
      error: DictationError.none,
    ));

    try {
      if (!_initialized) {
        _initialized = await _speech.initialize(
          onStopped: _handleStopped,
          onError: _handleError,
        );
        if (!_initialized) {
          final permitted = await _speech.hasPermission();
          if (isClosed) return;
          emit(state.copyWith(
            status: DictationStatus.idle,
            isAvailable: !permitted,
            error: permitted
                ? DictationError.unavailable
                : DictationError.permissionDenied,
          ));
          return;
        }
      }

      final localeId = resolveLocaleId(
        await _speech.localeIds(),
        languageCode,
      );
      if (isClosed || session != _session) return;

      await _speech.listen(
        localeId: localeId,
        onWords: (words) {
          if (isClosed || session != _session) return;
          emit(state.copyWith(recognizedWords: words));
        },
      );
      if (isClosed || session != _session) {
        await _speech.cancel();
        return;
      }
      if (state.status == DictationStatus.starting) {
        emit(state.copyWith(status: DictationStatus.listening));
      }
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: DictationStatus.idle,
        error: DictationError.failed,
      ));
    }
  }

  Future<void> stop() async {
    if (!state.isActive) return;
    if (state.status == DictationStatus.starting) return cancel();
    emit(state.copyWith(status: DictationStatus.idle));
    await _speech.stop();
  }

  Future<void> cancel() async {
    _session++;
    if (!state.isActive) return;
    emit(state.copyWith(status: DictationStatus.idle));
    await _speech.cancel();
  }

  void _handleStopped() {
    if (isClosed || !state.isActive) return;
    emit(state.copyWith(status: DictationStatus.idle));
  }

  void _handleError(SpeechRecognitionIssue issue) {
    if (isClosed) return;
    emit(state.copyWith(
      status: DictationStatus.idle,
      error: switch (issue) {
        SpeechRecognitionIssue.permissionDenied =>
          DictationError.permissionDenied,
        SpeechRecognitionIssue.noSpeech => DictationError.none,
        SpeechRecognitionIssue.failed => DictationError.failed,
      },
    ));
  }

  static String? resolveLocaleId(List<String> available, String? languageCode) {
    if (languageCode == null || languageCode.isEmpty) return null;
    final wanted = languageCode.toLowerCase();
    for (final id in available) {
      final language = id.split(RegExp('[-_]')).first.toLowerCase();
      if (language == wanted) return id;
    }
    return null;
  }

  @override
  Future<void> close() async {
    if (state.isActive) await _speech.cancel();
    return super.close();
  }
}
