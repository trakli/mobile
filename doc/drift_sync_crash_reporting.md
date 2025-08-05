# Drift Sync Crash Reporting Integration

This document explains how to integrate crash reporting with the `drift_sync_core` package to track errors and logs in your Crashlytics instance.

## Overview

The integration allows all errors and logs from the `drift_sync_core` package to be automatically forwarded to your main app's crash reporting service (Firebase Crashlytics, Sentry, etc.).

## Architecture

### Components

1. **`DriftSyncCrashReportingInterface`** - Abstract interface in the drift_sync_core package
2. **`DriftSyncLogger`** - Enhanced logger that forwards logs to crash reporting
3. **`DriftSyncCrashReportingAdapter`** - Adapter that implements the interface and connects to your crash reporting service
4. **`DriftSyncCrashReportingService`** - Service to manage the integration

### Flow

```
drift_sync_core → DriftSyncLogger → DriftSyncCrashReportingInterface →
DriftSyncCrashReportingAdapter → CrashReportingService → Firebase Crashlytics
```

## Setup

### 1. Automatic Setup

The integration is automatically initialized in your `bootstrap.dart` file:

```dart
// Initialize crash reporting
final crashReportingService = getIt<CrashReportingService>();
await crashReportingService.initialize();

// Initialize drift sync crash reporting
final driftSyncCrashReportingService = getIt<DriftSyncCrashReportingService>();
await driftSyncCrashReportingService.initialize();
```

### 2. Manual Setup (if needed)

If you need to set it up manually:

```dart
// Get the services
final crashReportingService = getIt<CrashReportingService>();
final driftSyncCrashReportingService = getIt<DriftSyncCrashReportingService>();

// Initialize
await driftSyncCrashReportingService.initialize();
```

## Usage

### Automatic Error Tracking

All errors in the drift sync operations are automatically tracked:

- **Sync Errors**: Errors during synchronization operations
- **Database Errors**: Errors during database operations
- **Network Errors**: Errors during API calls
- **Validation Errors**: Errors during data validation

### Setting User Context

```dart
final driftSyncCrashReportingService = getIt<DriftSyncCrashReportingService>();

// Set user context for drift sync operations
await driftSyncCrashReportingService.setUserContext(
  'user123',
  {
    'subscription': 'premium',
    'appVersion': '1.0.0',
  },
);
```

### Setting Custom Keys

```dart
// Set custom keys for drift sync operations
await driftSyncCrashReportingService.setCustomKeys({
  'sync_frequency': 'hourly',
  'sync_batch_size': 100,
  'sync_timeout': 30000,
});
```

### Logging Operations

```dart
// Log a drift sync operation
await driftSyncCrashReportingService.logOperation(
  'full_sync',
  details: {
    'models_count': 5,
    'start_time': DateTime.now().toIso8601String(),
    'sync_type': 'full',
  },
);
```

### Manual Error Recording

```dart
// Record a drift sync error
await driftSyncCrashReportingService.recordSyncError(
  error,
  stackTrace: stackTrace,
  operation: 'upload_changes',
  details: {
    'entity_type': 'Transaction',
    'changes_count': 10,
  },
);

// Record a fatal error
await driftSyncCrashReportingService.recordSyncFatalError(
  error,
  stackTrace: stackTrace,
  operation: 'database_migration',
  details: {
    'migration_version': '2.0.0',
    'database_size': '50MB',
  },
);
```

## What Gets Tracked

### Automatic Tracking

The following are automatically tracked by the drift sync package:

1. **Sync Operations**:

   - Start/stop of sync operations
   - Sync state changes
   - Handler initialization

2. **Errors**:

   - Network errors during sync
   - Database errors
   - Validation errors
   - Cancellation errors

3. **Performance**:
   - Sync duration
   - Handler processing time
   - Batch processing metrics

### Custom Information

Each error includes:

- **Component**: `drift_sync_core`
- **Operation**: The specific operation being performed
- **Entity Type**: The type of entity being synced
- **Error Context**: Additional context about the error

## Example Crash Reports

### Sync Error

```
Error: Drift Sync Error: upload_changes
Component: drift_sync_core
Operation: upload_changes
Entity Type: Transaction
Changes Count: 10
Message: Failed to upload local changes to server
```

### Database Error

```
Error: Drift Sync Error: database_operation
Component: drift_sync_core
Operation: upsert_local
Entity Type: User
Message: Failed to upsert user data locally
```

## Configuration

### Environment-Specific Settings

```dart
// In your bootstrap function
if (Environment.dev == env) {
  // Disable crash reporting for drift sync in development
  await driftSyncCrashReportingService.setCustomKeys({
    'drift_sync_crash_reporting_enabled': false,
  });
} else {
  // Enable crash reporting in production
  await driftSyncCrashReportingService.setCustomKeys({
    'drift_sync_crash_reporting_enabled': true,
  });
}
```

### Custom Error Filtering

You can filter which errors get reported by modifying the adapter:

```dart
@override
Future<void> recordError(
  Object error, {
  StackTrace? stackTrace,
  String? reason,
  Map<String, dynamic>? information,
}) async {
  // Only report certain types of errors
  if (error is NetworkException || error is DatabaseException) {
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
}
```

## Testing

### Unit Testing

```dart
test('drift sync crash reporting integration', () async {
  // Mock the crash reporting service
  final mockCrashReporting = MockCrashReportingService();
  final adapter = DriftSyncCrashReportingAdapter(mockCrashReporting);

  // Set up drift sync logger
  DriftSyncLogger.setCrashReporting(adapter);

  // Trigger an error
  try {
    throw Exception('Test error');
  } catch (error) {
    DriftSyncLogger.error('Test error message', error);
  }

  // Verify the error was recorded
  verify(mockCrashReporting.recordError(any, reason: anyNamed('reason')));
});
```

### Integration Testing

```dart
testWidgets('drift sync crash reporting in app', (tester) async {
  await tester.pumpWidget(MyApp());

  // Trigger a sync operation that might fail
  // Verify errors are recorded in crash reporting
});
```

## Troubleshooting

### Common Issues

1. **No errors being reported**:

   - Check that `DriftSyncCrashReportingService.initialize()` was called
   - Verify the crash reporting service is properly configured
   - Check that the adapter is properly injected

2. **Missing context information**:

   - Ensure user context is set before sync operations
   - Verify custom keys are being set correctly

3. **Performance impact**:
   - Crash reporting operations are asynchronous and shouldn't block sync
   - Consider filtering less critical errors in high-volume scenarios

### Debug Mode

Enable debug logging to see what's being sent to crash reporting:

```dart
// In debug mode, log all operations
if (kDebugMode) {
  await driftSyncCrashReportingService.logOperation(
    'debug_sync_start',
    details: {'debug_mode': true},
  );
}
```

## Best Practices

1. **Set User Context Early**: Set user context as soon as the user logs in
2. **Use Descriptive Operations**: Use clear, descriptive operation names
3. **Include Relevant Details**: Add context that will help with debugging
4. **Filter Appropriately**: Don't report every minor error
5. **Monitor Performance**: Watch for any performance impact from crash reporting

## Migration from Previous Versions

If you were previously using manual error handling in drift sync operations, you can now remove that code as errors are automatically tracked.

### Before

```dart
try {
  await synchronizer.sync();
} catch (error, stackTrace) {
  await crashReporting.recordError(error, stackTrace: stackTrace);
  rethrow;
}
```

### After

```dart
// Errors are automatically tracked
await synchronizer.sync();
```

The integration provides comprehensive error tracking for drift sync operations while maintaining clean, readable code.
