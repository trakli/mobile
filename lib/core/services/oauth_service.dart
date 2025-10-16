import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/utils/services/logger.dart' show logger;
import 'package:trakli/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Service to handle OAuth authentication with backend API integration
/// Supports Google and Apple Sign-In with JWT token management
@injectable
class OAuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final Dio _dio;

  // Backend API configuration
  static const String _baseUrl = 'https://8a0feab06bf3.ngrok-free.app/api';

  OAuthService()
      : _googleSignIn = GoogleSignIn.instance,
        _firebaseAuth = FirebaseAuth.instance,
        _dio = Dio() {
    logger.i('OAuthService initialized with backend integration');
    _setupDio();
  }

  /// Setup Dio HTTP client with interceptors
  void _setupDio() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add request interceptor for logging
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.d('HTTP Request: ${options.method} ${options.path}');
        handler.next(options);
      },
      onError: (error, handler) {
        logger.e('HTTP Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  /// Sign in with Google using backend API
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    logger.i('Starting Google sign-in process with backend integration');
    try {
      logger.d('Initializing Google Sign-In');

      if (Platform.isAndroid) {
        await _googleSignIn.initialize(
          clientId:
              "741084555946-fl3pj0gor0eqgat9pe5lkucr3a7jk5ud.apps.googleusercontent.com",
        );
      }
      logger.d('Google Sign-In initialized successfully');

      // Trigger the authentication flow
      logger.d('Starting Google authentication flow');
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      logger
          .i('Google authentication successful for user: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      logger.d('Retrieved Google authentication details');

      if (googleAuth.idToken == null) {
        logger.e('Google ID token is null - authentication failed');
        return const Left(ServerFailure('Failed to get Google ID token'));
      }
      logger.d('Google ID token obtained successfully');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      logger.d('Created Firebase credential from Google auth');

      // Once signed in, return the UserCredential
      logger.d('Signing in to Firebase with Google credential');
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        logger.e('Firebase user is null after credential sign-in');
        return const Left(ServerFailure('Firebase authentication failed'));
      }
      logger.i(
          'Firebase authentication successful for user: ${firebaseUser.uid}');

      // Send Firebase ID token to backend for JWT generation
      logger.d('Sending Firebase ID token to backend for JWT generation');
      final idToken = await firebaseUser.getIdToken();

      // Get device information
      return await apiCallVerifyToken(idToken, firebaseUser);
    } catch (e) {
      logger.e('Google sign-in failed: ${e.toString()}');
      return Left(ServerFailure('Google sign-in failed: ${e.toString()}'));
    }
  }

  Future<Either<Failure, UserEntity>> apiCallVerifyToken(
      String? idToken, User firebaseUser) async {
    // Get device information
    final deviceInfo = await _getDeviceInfo();
    logger.d('Device info collected: ${deviceInfo.toString()}');

    final response = await _dio.post('/v1/auth/verify-token', data: {
      'idToken': idToken,
      'deviceInfo': deviceInfo,
    });

    if (response.statusCode == 200) {
      final data = response.data['data'];
      final token = data['token'];
      final userData = data['user'];

      // Log JWT token and user data (no storage)
      logger.i('JWT token received: ${token.substring(0, 20)}...');
      logger.i('User data received: ${userData.toString()}');

      // Create user entity from Firebase user
      final user = UserEntity(
        id: int.tryParse(firebaseUser.uid) ?? 0,
        email: firebaseUser.email ?? '',
        firstName: firebaseUser.displayName?.split(' ').first ?? '',
        lastName: firebaseUser.displayName?.split(' ').skip(1).join(' '),
      );

      logger.i('Google sign-in completed successfully for user: ${user.email}');
      return Right(user);
    } else {
      logger.e('Backend JWT generation failed: ${response.statusCode}');
      return const Left(ServerFailure('Backend JWT generation failed'));
    }
  }

  /// Sign in with Apple using backend API
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    logger.i('Starting Apple sign-in process with backend integration');
    try {
      if (Platform.isAndroid) {
        return signInAndSignoutWithApple();
      }
      // await signOut();
      // Check if Apple Sign-In is available
      logger.d('Checking Apple Sign-In availability');
      if (!await SignInWithApple.isAvailable()) {
        logger.e('Apple Sign-In is not available on this device');
        return const Left(
            ServerFailure('Apple Sign-In is not available on this device'));
      }
      logger.d('Apple Sign-In is available');

      // To prevent replay attacks with the credential returned from Apple,
      // we include a nonce in the credential request.
      logger.d('Generating nonce for Apple authentication');
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);
      logger.d('Nonce generated and hashed successfully');

      // Request credential for the currently signed in Apple account
      logger.d('Requesting Apple ID credential');
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      logger.i('Apple ID credential obtained successfully');

      if (appleCredential.identityToken == null) {
        logger.e('Apple identity token is null - authentication failed');
        return const Left(ServerFailure('Failed to get Apple identity token'));
      }
      logger.d('Apple identity token obtained successfully');

      // Create an `OAuthCredential` from the credential returned by Apple
      logger.d('Creating Firebase OAuth credential from Apple auth');
      // final oauthCredential = OAuthProvider("apple.com").credential(
      //   idToken: appleCredential.identityToken,
      //   rawNonce: rawNonce,
      // );

      final fullName = AppleFullPersonName(
        familyName: appleCredential.familyName ?? '',
        givenName: appleCredential.givenName ?? '',
      );
      final credential = AppleAuthProvider.credentialWithIDToken(
        appleCredential.identityToken!,
        rawNonce,
        fullName,
      );

      logger.d('Firebase OAuth credential created successfully');

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      logger.d('Signing in to Firebase with Apple credential');
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      // String? authCode = userCredential.additionalUserInfo?.authorizationCode;
      // Revoke Apple auth token
      // await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode!);

      if (firebaseUser == null) {
        logger.e('Firebase user is null after Apple credential sign-in');
        return const Left(ServerFailure('Firebase authentication failed'));
      }
      logger.i(
          'Firebase authentication successful for user: ${firebaseUser.uid}');

      // Get device information
      final deviceInfo = await _getDeviceInfo();
      logger.d('Device info collected: ${deviceInfo.toString()}');

      // Send Firebase ID token to backend for JWT generation
      logger.d('Sending Firebase ID token to backend for JWT generation');
      final idToken = await firebaseUser.getIdToken();
      final response = await _dio.post('/v1/auth/verify-token', data: {
        'idToken': idToken,
        'deviceInfo': deviceInfo,
      });

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final token = data['token'];
        final userData = data['user'];

        // Log JWT token and user data (no storage)
        logger.i('JWT token received: ${token.substring(0, 20)}...');
        logger.i('User data received: ${userData.toString()}');

        // Create user entity from Firebase user
        final user = UserEntity(
          id: int.tryParse(firebaseUser.uid) ?? 0,
          email: firebaseUser.email ?? '',
          firstName: firebaseUser.displayName?.split(' ').first ?? '',
          lastName: firebaseUser.displayName?.split(' ').skip(1).join(' '),
        );

        logger
            .i('Apple sign-in completed successfully for user: ${user.email}');
        return Right(user);
      } else {
        logger.e('Backend JWT generation failed: ${response.statusCode}');
        return const Left(ServerFailure('Backend JWT generation failed'));
      }
    } catch (e) {
      logger.e('Apple sign-in failed: ${e.toString()}');
      return Left(ServerFailure('Apple sign-in failed: ${e.toString()}'));
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Either<Failure, UserEntity>> signInAndSignoutWithApple() async {
    // final appleProvider = AppleAuthProvider();

    AppleAuthProvider appleProvider = AppleAuthProvider();

// add required 'email' scope
    appleProvider = appleProvider.addScope('email');

// add optional 'name' scope
    appleProvider = appleProvider.addScope('name');

// show the Apple sign in UI
    final userCredential =
        await FirebaseAuth.instance.signInWithProvider(appleProvider);
    final User? firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      logger.e('Firebase user is null after credential sign-in');
      return const Left(ServerFailure('Firebase authentication failed'));
    }

    final idToken = await firebaseUser.getIdToken();
    return await apiCallVerifyToken(idToken, firebaseUser);

    // UserCredential userCredential =
    //     await FirebaseAuth.instance.signInWithPopup(appleProvider);
    // // Keep the authorization code returned from Apple platforms
    // String? authCode = userCredential.additionalUserInfo?.authorizationCode;
    // // Revoke Apple auth token
    // await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode!);
  }

  /// Sign out from all services and clear stored data
  Future<void> signOut() async {
    logger.i('Starting sign-out process');
    try {
      // Sign out from backend
      logger.d('Signing out from backend');
      try {
        await _dio.post('/auth/logout');
        logger.d('Backend sign-out completed');
      } catch (e) {
        logger.w('Backend sign-out failed: ${e.toString()}');
      }

      // await signInAndSignoutWithApple();

      // Log token clearing (no storage)
      logger.d('Clearing authentication data (logging only)');
      _logTokenClearing();

      // Sign out from Google
      logger.d('Signing out from Google');
      await _googleSignIn.signOut();
      logger.d('Google sign-out completed');

      // Sign out from Firebase
      logger.d('Signing out from Firebase');
      await _firebaseAuth.signOut();
      logger.d('Firebase sign-out completed');

      logger.i('Sign-out process completed successfully');
    } catch (e) {
      logger.e('Sign-out failed: ${e.toString()}');
      rethrow;
    }
  }

  /// Get current Firebase user
  User? get currentUser {
    final user = _firebaseAuth.currentUser;
    logger.d('Current Firebase user: ${user?.uid ?? 'null'}');
    return user;
  }

  /// Check if user is signed in
  bool get isSignedIn {
    final signedIn = _firebaseAuth.currentUser != null;
    logger.d('User signed in status: $signedIn');
    return signedIn;
  }

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges {
    logger.d('Setting up auth state changes stream');
    return _firebaseAuth.authStateChanges();
  }

  /// Check if Google Sign-In is available
  bool get isGoogleSignInAvailable {
    logger.d('Google Sign-In availability: true (available on all platforms)');
    return true; // Google Sign-In is available on all platforms
  }

  /// Check if Apple Sign-In is available
  Future<bool> get isAppleSignInAvailable async {
    logger.d('Checking Apple Sign-In availability');
    final available = await SignInWithApple.isAvailable();
    logger.d('Apple Sign-In availability: $available');
    return available;
  }

  /// Get device information for backend
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();

      Map<String, dynamic> deviceData = {
        'appVersion': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'packageName': packageInfo.packageName,
      };

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData.addAll({
          'deviceId': androidInfo.id,
          'deviceType': 'Android',
          'osVersion': 'Android ${androidInfo.version.release}',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData.addAll({
          'deviceId': iosInfo.identifierForVendor,
          'deviceType': 'iOS',
          'osVersion': 'iOS ${iosInfo.systemVersion}',
          'model': iosInfo.model,
          'name': iosInfo.name,
        });
      }

      return deviceData;
    } catch (e) {
      logger.e('Failed to get device info: ${e.toString()}');
      return {
        'deviceType': Platform.isIOS ? 'iOS' : 'Android',
        'appVersion': '1.0.0',
      };
    }
  }

  /// Log user data (no storage)
  void _logUserData(Map<String, dynamic> userData) {
    logger.d('User data: ${userData.toString()}');
  }

  /// Log token clearing (no storage)
  void _logTokenClearing() {
    logger.d('Authentication data cleared (logging only)');
  }

  /// Refresh JWT token (logging only)
  Future<Either<Failure, String>> refreshToken() async {
    try {
      logger.d('Token refresh requested (no stored token available)');
      logger.e('Token refresh not available - no persistent storage');
      return const Left(
          ServerFailure('Token refresh not available - no persistent storage'));
    } catch (e) {
      logger.e('Token refresh error: ${e.toString()}');
      return Left(ServerFailure('Token refresh failed: ${e.toString()}'));
    }
  }

  /// Get user profile from backend
  Future<Either<Failure, Map<String, dynamic>>> getUserProfile() async {
    try {
      logger.d('Fetching user profile from backend');
      final response = await _dio.get('/user/profile');

      if (response.statusCode == 200) {
        final userData = response.data['data']['user'];
        logger.i('User profile fetched successfully');
        return Right(userData);
      } else {
        logger.e('Failed to fetch user profile: ${response.statusCode}');
        return const Left(ServerFailure('Failed to fetch user profile'));
      }
    } catch (e) {
      logger.e('Get user profile error: ${e.toString()}');
      return Left(
          ServerFailure('Failed to fetch user profile: ${e.toString()}'));
    }
  }

  /// Update user profile
  Future<Either<Failure, Map<String, dynamic>>> updateUserProfile({
    String? firstName,
    String? lastName,
    String? displayName,
  }) async {
    try {
      logger.d('Updating user profile');
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (displayName != null) data['displayName'] = displayName;

      final response = await _dio.put('/user/profile', data: data);

      if (response.statusCode == 200) {
        final userData = response.data['data']['user'];
        _logUserData(userData);
        logger.i('User profile updated successfully');
        return Right(userData);
      } else {
        logger.e('Failed to update user profile: ${response.statusCode}');
        return const Left(ServerFailure('Failed to update user profile'));
      }
    } catch (e) {
      logger.e('Update user profile error: ${e.toString()}');
      return Left(
          ServerFailure('Failed to update user profile: ${e.toString()}'));
    }
  }

  /// Check if user is authenticated (logging only)
  Future<bool> isAuthenticated() async {
    try {
      logger.d('Authentication check requested (no stored token available)');
      logger.w('Authentication check not available - no persistent storage');
      return false;
    } catch (e) {
      logger.e('Authentication check failed: ${e.toString()}');
      return false;
    }
  }

  /// Get current user data (logging only)
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    logger.d('Get current user data requested (no stored data available)');
    logger.w('User data not available - no persistent storage');
    return null;
  }
}
