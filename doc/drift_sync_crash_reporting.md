# Drift Sync Crash Reporting

This guide shows how to automatically track errors from the `drift_sync_core` package in your crash reporting system (like Firebase Crashlytics).

## What It Does

Instead of manually catching and reporting every drift sync error, this integration automatically forwards all errors and logs to your main crash reporting service.

## Quick Setup

The integration is already set up in your `bootstrap.dart`:

```dart
// Initialize crash reporting
final crashReportingService = getIt<CrashReportingService>();
await crashReportingService.initialize();

// Initialize drift sync crash reporting
final driftSyncCrashReportingService = getIt<DriftSyncCrashReportingService>();
await driftSyncCrashReportingService.initialize();
```

That's it! All drift sync errors will now be automatically tracked.

## What Gets Tracked

### Automatic Error Tracking

- **Sync errors** - When synchronization fails
- **Database errors** - When database operations fail
- **Network errors** - When API calls fail
- **Validation errors** - When data validation fails

### What You Get

Each error report includes:

- The specific operation that failed
- The type of data being synced
- Additional context about the error
- User information (if set)

## Setting User Context

```dart
final driftSyncCrashReportingService = getIt<DriftSyncCrashReportingService>();

// Set user info for better error tracking
await driftSyncCrashReportingService.setUserContext(
  'user123',
  {
    'subscription': 'premium',
    'appVersion': '1.0.0',
  },
);
```

## Adding Custom Information

```dart
// Add custom data to all drift sync error reports
await driftSyncCrashReportingService.setCustomKeys({
  'sync_frequency': 'hourly',
  'sync_batch_size': 100,
});
```

## Manual Error Logging

If you need to log specific operations:

```dart
// Log a sync operation
await driftSyncCrashReportingService.logOperation(
  'full_sync',
  details: {
    'models_count': 5,
    'sync_type': 'full',
  },
);

// Record a specific error
await driftSyncCrashReportingService.recordSyncError(
  error,
  operation: 'upload_changes',
  details: {
    'entity_type': 'Transaction',
    'changes_count': 10,
  },
);
```

## Example Error Reports

### Sync Error

```
Error: Drift Sync Error: upload_changes
Operation: upload_changes
Entity Type: Transaction
Changes Count: 10
Message: Failed to upload local changes to server
```

### Database Error

```
Error: Drift Sync Error: database_operation
Operation: upsert_local
Entity Type: User
Message: Failed to upsert user data locally
```

## Environment Settings

```dart
// Disable in development, enable in production
if (Environment.dev == env) {
  await driftSyncCrashReportingService.setCustomKeys({
    'drift_sync_crash_reporting_enabled': false,
  });
} else {
  await driftSyncCrashReportingService.setCustomKeys({
    'drift_sync_crash_reporting_enabled': true,
  });
}
```

## Testing

```dart
test('drift sync crash reporting works', () async {
  final mockCrashReporting = MockCrashReportingService();
  final adapter = DriftSyncCrashReportingAdapter(mockCrashReporting);

  DriftSyncLogger.setCrashReporting(adapter);

  // Trigger an error
  try {
    throw Exception('Test error');
  } catch (error) {
    DriftSyncLogger.error('Test error message', error);
  }

  // Verify error was recorded
  verify(mockCrashReporting.recordError(any, reason: anyNamed('reason')));
});
```

## Troubleshooting

### No errors being reported?

- Make sure `DriftSyncCrashReportingService.initialize()` was called
- Check that your crash reporting service is properly configured

### Missing user context?

- Set user context before sync operations start
- Verify custom keys are being set correctly

### Performance issues?

- Crash reporting is async and shouldn't block sync operations
- Consider filtering less critical errors in high-volume scenarios

## Best Practices

1. **Set user context early** - Do it right after user login
2. **Use clear operation names** - "upload_transactions" instead of "sync"
3. **Add helpful details** - Include context that will help with debugging
4. **Don't over-report** - Focus on important errors, not every minor issue

## Migration

If you were manually catching drift sync errors before, you can now remove that code:

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

Much cleaner! 🎉
