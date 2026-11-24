import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum SpeechRecognitionIssue { permissionDenied, noSpeech, failed }

abstract class SpeechRecognitionService {
  Future<bool> initialize({
    required void Function() onStopped,
    required void Function(SpeechRecognitionIssue issue) onError,
  });

  Future<bool> hasPermission();

  Future<List<String>> localeIds();

  Future<void> listen({
    required void Function(String words) onWords,
    String? localeId,
  });

  Future<void> stop();

  Future<void> cancel();
}

@LazySingleton(as: SpeechRecognitionService)
class SpeechToTextRecognitionService implements SpeechRecognitionService {
  final SpeechToText _speech = SpeechToText();

  void Function()? _onStopped;
  void Function(SpeechRecognitionIssue issue)? _onError;

  @override
  Future<bool> initialize({
    required void Function() onStopped,
    required void Function(SpeechRecognitionIssue issue) onError,
  }) async {
    _onStopped = onStopped;
    _onError = onError;
    if (_speech.isAvailable) return true;
    return _speech.initialize(
      onStatus: _handleStatus,
      onError: _handleError,
      options: [SpeechToText.androidNoBluetooth],
    );
  }

  void _handleStatus(String status) {
    if (status == SpeechToText.doneStatus ||
        status == SpeechToText.notListeningStatus) {
      _onStopped?.call();
    }
  }

  void _handleError(SpeechRecognitionError error) {
    final code = error.errorMsg;
    final issue = switch (code) {
      'error_permission' ||
      'error_speech_recognizer_disabled' =>
        SpeechRecognitionIssue.permissionDenied,
      'error_no_match' ||
      'error_speech_timeout' =>
        SpeechRecognitionIssue.noSpeech,
      _ => SpeechRecognitionIssue.failed,
    };
    _onError?.call(issue);
  }

  @override
  Future<bool> hasPermission() => _speech.hasPermission;

  @override
  Future<List<String>> localeIds() async {
    final locales = await _speech.locales();
    return locales.map((l) => l.localeId).toList();
  }

  @override
  Future<void> listen({
    required void Function(String words) onWords,
    String? localeId,
  }) {
    return _speech.listen(
      onResult: (result) => onWords(result.recognizedWords),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
        localeId: localeId,
      ),
    );
  }

  @override
  Future<void> stop() => _speech.stop();

  @override
  Future<void> cancel() => _speech.cancel();
}
