import 'package:logging/logging.dart';
import 'crash_reporting_interface.dart';

/// Logger service for drift_sync_core that integrates with crash reporting
class DriftSyncLogger {
  static DriftSyncCrashReportingInterface? _crashReporting;
  static final Logger _logger = Logger('drift_sync_core');

  /// Set the crash reporting interface to be used for error tracking
  static void setCrashReporting(
      DriftSyncCrashReportingInterface crashReporting) {
    _crashReporting = crashReporting;
  }

  /// Get the underlying logger instance
  static Logger get logger => _logger;

  /// Log an error and optionally record it in crash reporting
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  ]) {
    _logger.severe(message, error, stackTrace);

    if (_crashReporting != null && error != null) {
      _crashReporting!.recordError(
        error,
        stackTrace: stackTrace,
        reason: reason ?? 'Drift Sync Error',
        information: {
          'message': message,
          'component': 'drift_sync_core',
          ...?information,
        },
      );
    }
  }

  /// Log a warning
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);

    if (_crashReporting != null) {
      _crashReporting!.log('WARNING: $message', level: 'warning');
    }
  }

  /// Log an info message
  static void info(String message) {
    _logger.info(message);

    if (_crashReporting != null) {
      _crashReporting!.log(message, level: 'info');
    }
  }

  /// Log a debug message
  static void debug(String message) {
    _logger.fine(message);

    if (_crashReporting != null) {
      _crashReporting!.log(message, level: 'debug');
    }
  }

  /// Log a fatal error and record it in crash reporting
  static void fatal(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  ]) {
    _logger.severe('FATAL: $message', error, stackTrace);

    if (_crashReporting != null && error != null) {
      _crashReporting!.recordFatalError(
        error,
        stackTrace: stackTrace,
        reason: reason ?? 'Drift Sync Fatal Error',
        information: {
          'message': message,
          'component': 'drift_sync_core',
          ...?information,
        },
      );
    }
  }
}
