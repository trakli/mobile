/// Interface for crash reporting in drift_sync_core package
/// This will allow the main app to provide a crash reporting implementation
/// that will be used by the drift_sync_core package for error tracking and logging
abstract class DriftSyncCrashReportingInterface {
  /// Record a non-fatal error from sync operations
  Future<void> recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  });

  /// Record a fatal error from sync operations
  Future<void> recordFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  });

  /// Log a message for debugging purposes
  Future<void> log(String message, {String? level});
}
