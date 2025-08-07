# Drift Sync Crash Reporting

This guide shows how to automatically track errors from the `drift_sync_core` package in the crash reporting system (like Firebase Crashlytics).

## What It Does

Instead of manually catching and reporting every drift sync error, this integration automatically forwards all errors and logs to your main crash reporting service.

## Quick Setup

The integration can be set up in the wrapper function around your app widget like `bootstrap.dart`:

```dart
// Initialize crash reporting
final crashReportingService = getIt<CrashReportingService>();
await crashReportingService.initialize();

// Initialize drift sync crash reporting
final driftSyncCrashReportingService = getIt<DriftSyncCrashReportingService>();
await driftSyncCrashReportingService.initialize();
```

With this All drift sync errors will now be automatically tracked.

## What Gets Tracked

### Automatic Error Tracking

- **Sync errors** - When synchronization fails
- **Database errors** - When database operations fail
- **Network errors** - When API calls fail
- **Validation errors** - When data validation fails

### What You Get

Each error report includes:

- The specific operation that failed
- The type of data being synced for example category etc
- Additional context about the error with include the error data for persistance
- User information :optional

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
