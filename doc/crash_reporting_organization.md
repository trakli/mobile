# Crash Reporting System - Organized Structure

## 📁 Final Directory Structure

The crash reporting system has been organized into a clean, maintainable structure:

```
lib/core/error/
├── crash_reporting/                    # Main crash reporting directory
│   ├── README.md                      # Directory documentation
│   ├── crash_reporting.dart           # Barrel export file
│   ├── crash_reporting_interface.dart # Abstract interface
│   ├── crash_reporting_service.dart   # Main service class
│   ├── implementations/               # Provider implementations
│   │   └── firebase_crashlytics_service.dart
│   └── examples/                      # Usage examples
│       └── crash_reporting_example.dart
├── crash_reporting.dart               # Main export file (legacy)
├── error_handler.dart                 # Updated with crash reporting integration
├── exceptions.dart
├── repository_error_handler.dart
├── dio_error_handler.dart
├── failures/
└── utils/
```

## 🏗️ Architecture Overview

### Core Components

1. **`CrashReportingInterface`** - Abstract interface defining the contract
2. **`CrashReportingService`** - Main service providing easy access to functionality
3. **`FirebaseCrashlyticsService`** - Firebase implementation
4. **`ErrorHandler`** - Updated to automatically record errors

### Key Improvements

✅ **Organized Structure**: Files are now properly organized in subdirectories
✅ **Logger Integration**: All fallback logging now uses the app's logger instead of print statements
✅ **Barrel Exports**: Clean import paths with barrel export files
✅ **Documentation**: Comprehensive README files for each directory
✅ **Examples**: Detailed usage examples for developers
✅ **Dependency Injection**: Fully integrated with the existing DI system

## 📦 Import Structure

### For Core Usage

```dart
import 'package:trakli/core/error/crash_reporting/crash_reporting.dart';
```

### For Specific Components

```dart
import 'package:trakli/core/error/crash_reporting/crash_reporting_interface.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';
```

## 🔧 Usage Examples

### Basic Error Recording

```dart
class MyRepository {
  final CrashReportingService _crashReporting;

  MyRepository(this._crashReporting);

  Future<void> someMethod() async {
    try {
      // Your code here
    } catch (error, stackTrace) {
      await _crashReporting.recordError(
        error,
        stackTrace: stackTrace,
        reason: 'Failed to perform operation',
      );
      rethrow;
    }
  }
}
```

### API Error Recording

```dart
await _crashReporting.recordApiError(
  '/api/endpoint',
  500,
  'Server error occurred',
  requestData: {'key': 'value'},
  responseData: {'error': 'details'},
);
```

### Setting User Context

```dart
await _crashReporting.setUserId('user123');
await _crashReporting.setUserProperties({
  'subscription': 'premium',
  'appVersion': '1.0.0',
});
```

## 🚀 Automatic Integration

The system automatically records:

- ✅ API errors (DioException)
- ✅ Unknown errors with stack traces
- ✅ Flutter framework errors
- ✅ Unhandled errors as fatal errors

## 🔄 Future Provider Support

When ready to add Sentry:

1. Create `lib/core/error/crash_reporting/implementations/sentry_crash_reporting_service.dart`
2. Implement `CrashReportingInterface`
3. Add export to `crash_reporting.dart`
4. Update DI configuration
5. No other code changes needed!

## 📚 Documentation

- **`doc/crash_reporting.md`** - Comprehensive system documentation
- **`lib/core/error/crash_reporting/README.md`** - Directory structure and usage
- **`lib/core/error/crash_reporting/examples/crash_reporting_example.dart`** - Detailed examples

## ✅ What's Ready

- ✅ Firebase Crashlytics integration
- ✅ Organized file structure
- ✅ Logger-based fallbacks
- ✅ Automatic error recording
- ✅ Dependency injection
- ✅ Comprehensive documentation
- ✅ Usage examples
- ✅ Clean import paths

The crash reporting system is now well-organized, maintainable, and ready for production use!
