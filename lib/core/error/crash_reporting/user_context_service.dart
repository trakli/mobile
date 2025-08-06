import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trakli/core/error/crash_reporting/crash_reporting_service.dart';
import 'package:trakli/core/utils/services/logger.dart';
import 'package:trakli/domain/entities/user_entity.dart';

/// Service for managing user context in crash reporting
/// This service provides a centralized way to set and clear user information
/// in crash reports for better debugging and user identification
@injectable
class UserContextService {
  final CrashReportingService _crashReportingService;

  // Cache to avoid redundant operations
  UserEntity? _currentUser;
  bool _isContextSet = false;
  PackageInfo? _packageInfo;

  UserContextService(this._crashReportingService);

  /// Get the current user context
  UserEntity? get currentUser => _currentUser;

  /// Check if user context is currently set
  bool get isContextSet => _isContextSet;

  /// Initialize package info (should be called once)
  Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      await setAppContext();
      logger.i('Package info initialized: ${_packageInfo?.version}');
    } catch (e, stackTrace) {
      logger.e('Failed to initialize package info: $e', stackTrace: stackTrace);
    }
  }

  /// Set user context in crash reporting
  /// This method sets the user ID, properties, and custom keys for better crash analysis
  /// Returns true if successful, false otherwise
  Future<bool> setUserContext(UserEntity user) async {
    try {
      // Avoid redundant operations if same user is already set
      if (_currentUser?.id == user.id && _isContextSet) {
        logger.d('User context already set for user: ${user.email}');
        return true;
      }

      logger.i('Setting user context for user: ${user.email}');

      // Set user ID (primary identifier)
      await _crashReportingService.setUserId(user.id.toString());

      // Set comprehensive user properties
      final userProperties = _buildUserProperties(user);
      await _crashReportingService.setUserProperties(userProperties);

      // Set app-specific context
      // await setAppContext();

      // Update internal state
      _currentUser = user;
      _isContextSet = true;

      logger.i('User context set successfully for user: ${user.email}');
      return true;
    } catch (e, stackTrace) {
      logger.e(
        'Failed to set user context in crash reporting: $e',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clear user context when user logs out
  /// This method removes all user-specific information from crash reports
  /// Returns true if successful, false otherwise
  Future<bool> clearUserContext() async {
    try {
      if (!_isContextSet) {
        logger.d('User context already cleared');
        return true;
      }

      logger.i('Clearing user context');

      // Clear user ID
      await _crashReportingService.setUserId('');

      // Clear user properties by setting them to empty/default values
      final emptyProperties = _buildEmptyUserProperties();
      await _crashReportingService.setUserProperties(emptyProperties);

      // Clear custom keys
      final emptyKeys = _buildEmptyCustomKeys();
      await _setCustomKeysBatch(emptyKeys);

      // Update internal state
      _currentUser = null;
      _isContextSet = false;

      logger.i('User context cleared successfully');
      return true;
    } catch (e, stackTrace) {
      logger.e(
        'Failed to clear user context in crash reporting: $e',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  // Private helper methods

  Map<String, dynamic> _buildUserProperties(UserEntity user) {
    return {
      'user_id': user.id,
      'email': user.email,
      'first_name': user.firstName,
      'last_name': user.lastName ?? '',
      'username': user.username ?? '',
      'phone': user.phone ?? '',
      'full_name': user.fullName,
      'has_phone': user.phone != null,
      'has_username': user.username != null,
      'has_last_name': user.lastName != null && user.lastName!.isNotEmpty,
    };
  }

  Map<String, dynamic> _buildEmptyUserProperties() {
    return {
      'user_id': '',
      'email': '',
      'first_name': '',
      'last_name': '',
      'username': '',
      'phone': '',
      'full_name': '',
      'has_phone': false,
      'has_username': false,
      'has_last_name': false,
    };
  }

  Map<String, dynamic> _buildEmptyCustomKeys() {
    return {
      'user_context_set': false,
    };
  }

  Future<void> setAppContext() async {
    // Get app version from package info
    final appVersion = _packageInfo?.version ?? 'unknown';
    final buildNumber = _packageInfo?.buildNumber ?? 'unknown';
    final appName = _packageInfo?.appName ?? 'Trakli';
    final packageName = _packageInfo?.packageName ?? 'com.trakli.app';

    await _crashReportingService.setCustomKey('app_version', appVersion);
    await _crashReportingService.setCustomKey('app_build_number', buildNumber);
    await _crashReportingService.setCustomKey('app_name', appName);
    await _crashReportingService.setCustomKey('package_name', packageName);
    await _crashReportingService.setCustomKey('user_context_set', true);
    await _crashReportingService.setCustomKey(
        'user_context_timestamp', DateTime.now().toIso8601String());
  }

  Future<void> _setCustomKeysBatch(Map<String, dynamic> keys) async {
    for (final entry in keys.entries) {
      await _crashReportingService.setCustomKey(entry.key, entry.value);
    }
  }
}
