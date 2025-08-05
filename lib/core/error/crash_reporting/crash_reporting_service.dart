import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_interface.dart';

/// Service class that provides easy access to crash reporting functionality
/// This acts as a facade for the crash reporting interface
@injectable
class CrashReportingService {
  final CrashReportingInterface _crashReporter;

  CrashReportingService(this._crashReporter);

  /// Initialize the crash reporting service
  Future<void> initialize() async {
    await _crashReporter.initialize();
  }

  /// Record a non-fatal error
  Future<void> recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    await _crashReporter.recordError(
      error,
      stackTrace: stackTrace,
      reason: reason,
      information: information,
    );
  }

  /// Record a fatal error/crash
  Future<void> recordFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    await _crashReporter.recordFatalError(
      error,
      stackTrace: stackTrace,
      reason: reason,
      information: information,
    );
  }

  /// Set a custom key-value pair for crash reports
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashReporter.setCustomKey(key, value);
  }

  /// Set user identifier for crash reports
  Future<void> setUserId(String userId) async {
    await _crashReporter.setUserId(userId);
  }

  /// Set user properties for crash reports
  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    await _crashReporter.setUserProperties(properties);
  }

  /// Log a message for debugging purposes
  Future<void> log(String message, {String? level}) async {
    await _crashReporter.log(message, level: level);
  }

  /// Convenience method to record API errors
  Future<void> recordApiError(
    String endpoint,
    int? statusCode,
    String message, {
    Map<String, dynamic>? requestData,
    Map<String, dynamic>? responseData,
  }) async {
    await recordError(
      Exception('API Error: $message'),
      reason: 'API Error',
      information: {
        'endpoint': endpoint,
        'statusCode': statusCode?.toString() ?? 'unknown',
        'requestData': requestData?.toString() ?? 'none',
        'responseData': responseData?.toString() ?? 'none',
      },
    );
  }
}
