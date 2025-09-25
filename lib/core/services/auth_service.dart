import 'package:injectable/injectable.dart';
import 'package:trakli/data/datasources/auth/token_manager.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/repositories/auth_repository.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/auth/pages/login_screen.dart';
import 'package:flutter/material.dart';

/// Service to handle authentication state changes globally
/// This service provides methods to handle authentication-related operations
/// such as logout, token validation, and navigation to login screen
@injectable
class AuthService {
  // final AuthRepository _authRepository;
  final TokenManager _tokenManager;

  AuthService(this._tokenManager);

  /// Handle 401 Unauthorized response by clearing auth state and navigating to login
  Future<void> handleUnauthorized() async {
    try {
      // Clear the token first
      await _tokenManager.clearToken();
      await getIt<AuthRepository>().logout();

      // Trigger logout through the repository to ensure all auth state is cleared
      // await _authRepository.logout();

      // Navigate to login screen
      _navigateToLogin();
    } catch (e) {
      // If there's an error during logout, at least clear the token and navigate
      await _tokenManager.clearToken();
      _navigateToLogin();
    }
  }

  /// Navigate to login screen and clear the navigation stack
  void _navigateToLogin() {
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenManager.hasToken;
  }

  /// Get the current auth token
  Future<String?> getCurrentToken() async {
    return await _tokenManager.token;
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    await _tokenManager.clearToken();
    // await _authRepository.logout();
  }
}
