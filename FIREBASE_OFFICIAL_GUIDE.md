# Firebase Social Authentication - Official Implementation Guide

This guide implements Firebase Social Authentication following the official [Firebase Flutter documentation](https://firebase.flutter.dev/docs/auth/social/).

## 🔥 Firebase Setup

### 1. Firebase Project Configuration

1. **Create Firebase Project**:

   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project: `trakli-auth`
   - Enable Google Analytics (optional)

2. **Enable Authentication Providers**:

   - Go to "Authentication" > "Sign-in method"
   - Enable "Google" provider
   - Enable "Apple" provider (for iOS)

3. **Download Service Account Key**:
   - Go to "Project Settings" > "Service accounts"
   - Click "Generate new private key"
   - Save as `firebase-service-account.json` in `oauth-test-server/`

### 2. Flutter App Configuration

Your Flutter app already has the required dependencies:

```yaml
dependencies:
  firebase_auth: ^5.3.1
  google_sign_in: ^7.1.1
  sign_in_with_apple: ^6.1.1
  crypto: ^3.0.6 # Required for Apple Sign-In nonce
```

## 📱 Implementation Details

### Google Sign-In Implementation

Following the [official Firebase documentation](https://firebase.flutter.dev/docs/auth/social/#google):

```dart
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
```

### Apple Sign-In Implementation

Following the [official Firebase documentation](https://firebase.flutter.dev/docs/auth/social/#apple) with nonce for security:

```dart
Future<UserCredential> signInWithApple() async {
  // Generate nonce for security
  final rawNonce = generateNonce();
  final nonce = sha256ofString(rawNonce);

  // Request credential for the currently signed in Apple account
  final appleCredential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: nonce,
  );

  // Create an `OAuthCredential` from the credential returned by Apple
  final oauthCredential = OAuthProvider("apple.com").credential(
    idToken: appleCredential.identityToken,
    rawNonce: rawNonce,
  );

  // Sign in the user with Firebase
  return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
}
```

## 🖥️ Backend Implementation

### Node.js Server with Firebase Admin SDK

The backend uses Firebase Admin SDK to verify and manage users:

```javascript
// Verify Firebase user
const firebaseUser = await admin.auth().getUser(uid)

// Create custom token (if needed)
const customToken = await admin.auth().createCustomToken(uid)

// Verify ID token
const decodedToken = await admin.auth().verifyIdToken(idToken)
```

## 🚀 Testing the Implementation

### 1. Start the Backend Server

```bash
cd oauth-test-server
chmod +x setup.sh
./setup.sh
npm run dev
```

### 2. Test Firebase Connection

```bash
curl http://localhost:3000/health
```

Expected response:

```json
{
  "success": true,
  "message": "Firebase OAuth server is running",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "firebase": "connected"
}
```

### 3. Test Flutter App

1. **Run your Flutter app**
2. **Tap "Proceed with Google"**
3. **Complete Google Sign-In**
4. **Check Firebase Console for the user**

## 🔧 Key Features

### Security Features

1. **Nonce for Apple Sign-In**: Prevents replay attacks
2. **Firebase ID Token Verification**: Server-side token validation
3. **Custom Token Generation**: Server-to-server authentication
4. **User Data Validation**: Firebase Admin SDK user verification

### Firebase Integration

1. **Native OAuth**: Uses official Google and Apple Sign-In packages
2. **Firebase Authentication**: Full Firebase Auth integration
3. **User Management**: Firebase Admin SDK for user operations
4. **Token Management**: Secure token handling and verification

## 📊 Monitoring

### Firebase Console

Monitor authentication in Firebase Console:

1. Go to Firebase Console > Authentication
2. Check "Users" tab for registered users
3. Check "Sign-in method" for enabled providers

### Server Logs

The server logs all Firebase authentication:

```
New Firebase user created: user@example.com
Existing Firebase user logged in: user@example.com
Firebase user verified: user@example.com
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Google Sign-In Not Working

**Error**: `Google sign-in failed` or popup doesn't appear

**Solutions**:

- Check Firebase Console > Authentication > Sign-in method > Google is enabled
- Verify SHA-1 fingerprint is added to Firebase project
- Test on a real device (not emulator)
- Check Google OAuth consent screen is configured

#### 2. Apple Sign-In Not Working

**Error**: `Apple Sign-In is not available`

**Solutions**:

- Apple Sign-In only works on iOS 13+ devices
- Test on a real iOS device
- Verify Apple Sign-In is enabled in Firebase Console
- Check Apple Developer account configuration

#### 3. Firebase Authentication Fails

**Error**: `Firebase authentication failed`

**Solutions**:

- Check Firebase project configuration
- Verify service account key is valid
- Check Firebase project ID matches
- Ensure Firebase Admin SDK is properly initialized

### Debug Commands

```bash
# Check server health
curl http://localhost:3000/health

# List all users
curl http://localhost:3000/api/v1/users

# Test Firebase user endpoint
curl -X POST http://localhost:3000/api/v1/auth/firebase-user \
  -H "Content-Type: application/json" \
  -d '{"uid": "test-uid", "email": "test@example.com"}'
```

## 🔒 Security Best Practices

### For Production

1. **Use HTTPS**: Always use HTTPS in production
2. **Environment Variables**: Store secrets in environment variables
3. **Firebase Security Rules**: Configure proper security rules
4. **Rate Limiting**: Add rate limiting and security middleware
5. **Token Validation**: Implement proper token validation
6. **User Data Protection**: Protect user data with proper access controls

### Firebase Security Rules

Example Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📚 Official Documentation References

- [Firebase Flutter Social Auth](https://firebase.flutter.dev/docs/auth/social/)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Apple Sign-In Flutter](https://pub.dev/packages/sign_in_with_apple)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin)

## 🎯 Success Criteria

Your implementation is working correctly if:

1. ✅ Firebase project is configured
2. ✅ Service account key is downloaded
3. ✅ Server starts without errors
4. ✅ Flutter app connects to Firebase
5. ✅ Google Sign-In popup appears
6. ✅ Apple Sign-In popup appears (on iOS)
7. ✅ Firebase authentication completes
8. ✅ User data is stored on server
9. ✅ Success messages appear in Flutter app
10. ✅ No authentication errors in logs

## 🚀 Next Steps

1. **Test the implementation** with the provided steps
2. **Configure production environment** with proper security
3. **Deploy to production** with HTTPS and proper domain
4. **Monitor authentication** through Firebase Console
5. **Implement additional features** as needed

This implementation follows the official Firebase documentation patterns and provides a secure, production-ready authentication system for your Flutter app.
