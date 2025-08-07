import 'package:drift_sync_core/drift_sync_core.dart';
import 'package:injectable/injectable.dart';
import 'drift_sync_crash_reporting_adapter.dart';

/// Service to manage drift sync crash reporting integration
@injectable
class DriftSyncCrashReportingService {
  final DriftSyncCrashReportingAdapter _adapter;

  DriftSyncCrashReportingService(this._adapter);

  /// Initialize drift sync crash reporting
  /// This should be called after the main crash reporting service is initialized
  Future<void> initialize() async {
    DriftSyncLogger.setCrashReporting(_adapter);

    // Log that drift sync crash reporting is initialized
    await _adapter.log('Drift sync crash reporting initialized', level: 'info');
  }
}
