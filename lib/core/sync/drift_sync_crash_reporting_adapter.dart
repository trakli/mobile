import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';

/// Adapter that implements the drift sync crash reporting interface
/// and connects it to the main app's crash reporting service
@injectable
class DriftSyncCrashReportingAdapter
    implements DriftSyncCrashReportingInterface {
  final CrashReportingService _crashReporting;

  DriftSyncCrashReportingAdapter(this._crashReporting);

  @override
  Future<void> recordError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    await _crashReporting.recordError(
      error,
      stackTrace: stackTrace,
      reason: reason ?? 'Drift Sync Error',
      information: {
        'component': 'drift_sync_core',
        ...?information,
      },
    );
  }

  @override
  Future<void> recordFatalError(
    Object error, {
    StackTrace? stackTrace,
    String? reason,
    Map<String, dynamic>? information,
  }) async {
    await _crashReporting.recordFatalError(
      error,
      stackTrace: stackTrace,
      reason: reason ?? 'Drift Sync Fatal Error',
      information: {
        'component': 'drift_sync_core',
        ...?information,
      },
    );
  }

  @override
  Future<void> log(String message, {String? level}) async {
    await _crashReporting.log(message, level: level);
  }
}
