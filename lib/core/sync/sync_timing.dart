import 'dart:async';

import 'package:trakli/core/utils/services/logger.dart';

class SyncTiming {
  static const _baseDelay = Duration(seconds: 2);
  static const _maxDelay = Duration(minutes: 30);
  static const _maxAttempts = 10;
  static const _exponentialFactor = 1.5;

  Timer? _syncTimer;
  Duration _currentDelay = _baseDelay;
  int _attempts = 0;

  void resetTiming() {
    _currentDelay = _baseDelay;
    _attempts = 0;
    logger.info('Sync timing reset to base delay: $_baseDelay');
  }

  void increaseDelay() {
    _currentDelay = Duration(
      milliseconds: (_currentDelay.inMilliseconds * _exponentialFactor).toInt(),
    );

    if (_currentDelay > _maxDelay) {
      _currentDelay = _maxDelay;
    }

    _attempts++;
    logger.info('Sync delay increased to: $_currentDelay (attempt $_attempts)');
  }

  void scheduleSync(Future<void> Function() syncFunction) {
    if (_attempts >= _maxAttempts) {
      logger.warning('Max sync attempts reached ($_maxAttempts)');
      return;
    }

    _syncTimer?.cancel();
    _syncTimer = Timer(_currentDelay, () async {
      try {
        await syncFunction();
        resetTiming();
      } catch (e) {
        logger.e('Scheduled sync failed: $e');
        increaseDelay();
        scheduleSync(syncFunction);
      }
    });
  }

  void cancelSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    logger.info('Sync cancelled');
  }
}
