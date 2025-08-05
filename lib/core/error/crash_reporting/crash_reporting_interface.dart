/// Interface for crash reporting services
/// This allows for easy switching between different crash reporting providers
/// like Firebase Crashlytics, Sentry, etc.
abstract class CrashReportingInterface {
  /// Initialize the crash reporting service
  Future<void> initialize();

  /// Record a non-fatal error
  ///
  /// [error] - The error object
  /// [stackTrace] - The stack trace (optional)
  /// [reason] - Custom reason for the error (optional)
  /// [information] - Additional information to include (optional)
  Future<void> recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  });

  /// Record a fatal error/crash
  ///
  /// [error] - The error object
  /// [stackTrace] - The stack trace (optional)
  /// [reason] - Custom reason for the error (optional)
  /// [information] - Additional information to include (optional)
  Future<void> recordFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  });

  /// Set a custom key-value pair for crash reports
  ///
  /// [key] - The key
  /// [value] - The value
  Future<void> setCustomKey(String key, dynamic value);

  /// Set user identifier for crash reports
  ///
  /// [userId] - The user ID
  Future<void> setUserId(String userId);

  /// Set user properties for crash reports
  ///
  /// [properties] - Map of user properties
  Future<void> setUserProperties(Map<String, dynamic> properties);

  /// Log a message for debugging purposes
  ///
  /// [message] - The message to log
  /// [level] - The log level (optional)
  Future<void> log(String message, {String? level});
}
