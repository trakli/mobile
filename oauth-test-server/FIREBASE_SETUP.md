# Firebase Setup Guide

This guide will help you configure Firebase Authentication for your Flutter app and Node.js backend.

## 🔥 Firebase Project Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `trakli-auth` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

### 2. Enable Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable the following providers:

#### Google Sign-In

1. Click on "Google"
2. Toggle "Enable"
3. Add your project support email
4. Click "Save"

#### Apple Sign-In

1. Click on "Apple"
2. Toggle "Enable"
3. Enter your Apple Service ID (e.g., `com.whilesmart.trakli`)
4. Enter your Apple Team ID
5. Enter your Apple Key ID
6. Upload your Apple private key (.p8 file)
7. Click "Save"

### 3. Configure OAuth Consent Screen

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to "APIs & Services" > "OAuth consent screen"
4. Configure the consent screen:
   - User Type: External
   - App name: Trakli
   - User support email: your-email@example.com
   - Developer contact: your-email@example.com
5. Add scopes: `email`, `profile`, `openid`
6. Add test users (for development)

### 4. Configure OAuth Credentials

1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth 2.0 Client IDs"
3. Application type: "Web application"
4. Name: "Trakli Web Client"
5. Authorized redirect URIs:
   - `http://localhost:3000/auth/google/callback`
   - `https://your-domain.com/auth/google/callback`
6. Click "Create"

## 📱 Flutter App Configuration

### 1. Add Firebase to Flutter

Your Flutter app already has Firebase configured. Make sure these files exist:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

### 2. Configure Google Sign-In

Update your `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        applicationId "com.whilesmart.trakli"
        // ... other config
    }
}
```

### 3. Configure Apple Sign-In (iOS)

1. In Xcode, open your iOS project
2. Go to "Signing & Capabilities"
3. Add "Sign In with Apple" capability
4. Make sure your bundle ID matches Firebase configuration

## 🖥️ Backend Configuration

### 1. Download Service Account Key

1. Go to Firebase Console > Project Settings
2. Go to "Service accounts" tab
3. Click "Generate new private key"
4. Download the JSON file
5. Save it as `firebase-service-account.json` in your server directory

### 2. Environment Variables

Create a `.env` file in your server directory:

```env
PORT=3000
JWT_SECRET=your-super-secret-jwt-key
FIREBASE_PROJECT_ID=your-firebase-project-id
```

### 3. Install Dependencies

```bash
cd oauth-test-server
npm install
```

## 🧪 Testing the Setup

### 1. Start the Server

```bash
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

1. Run your Flutter app
2. Tap "Proceed with Google"
3. Complete Google Sign-In
4. Check server logs for user creation

## 🔧 Troubleshooting

### Common Issues

#### 1. Firebase Service Account Error

**Error**: `Firebase service account key not found!`

**Solution**:

- Download service account key from Firebase Console
- Save as `firebase-service-account.json` in server directory
- Make sure the file is in the correct location

#### 2. Google Sign-In Not Working

**Error**: `Google sign-in failed` or popup doesn't appear

**Solutions**:

- Check your Google Client ID in Firebase Console
- Verify SHA-1 fingerprint is added to Firebase project
- Make sure OAuth consent screen is configured
- Test on a real device (not emulator)

#### 3. Apple Sign-In Not Working

**Error**: `Apple Sign-In is not available`

**Solutions**:

- Apple Sign-In only works on iOS 13+ devices
- Make sure you're testing on a real iOS device
- Verify Apple Sign-In is enabled in Firebase Console
- Check your Apple Developer account configuration

#### 4. Firebase Authentication Fails

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

# Test Firebase token endpoint
curl -X POST http://localhost:3000/api/v1/auth/firebase-token \
  -H "Content-Type: application/json" \
  -d '{"uid": "test-uid", "email": "test@example.com"}'
```

## 🚀 Production Deployment

### 1. Environment Variables

Set these environment variables in production:

```env
PORT=3000
JWT_SECRET=your-production-jwt-secret
FIREBASE_PROJECT_ID=your-firebase-project-id
NODE_ENV=production
```

### 2. Security Considerations

- Use environment variables for secrets
- Enable Firebase Security Rules
- Use HTTPS in production
- Implement rate limiting
- Add proper error handling
- Use a production database

### 3. Firebase Security Rules

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

## 📚 Additional Resources

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Firebase Admin SDK Documentation](https://firebase.google.com/docs/admin)
- [Flutter Firebase Auth](https://firebase.flutter.dev/docs/auth/overview/)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Apple Sign-In Flutter](https://pub.dev/packages/sign_in_with_apple)
