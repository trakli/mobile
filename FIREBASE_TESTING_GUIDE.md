# Firebase Authentication Testing Guide

This guide will help you test the Firebase Authentication implementation with your Flutter app and Node.js backend.

## 🔥 Firebase Setup (Required First)

### 1. Firebase Project Setup

1. **Create Firebase Project**:

   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Create a project"
   - Name: `trakli-auth`
   - Enable Google Analytics (optional)

2. **Enable Authentication**:

   - Go to "Authentication" > "Get started"
   - Go to "Sign-in method" tab
   - Enable "Google" provider
   - Enable "Apple" provider (for iOS)

3. **Download Service Account Key**:
   - Go to "Project Settings" > "Service accounts"
   - Click "Generate new private key"
   - Save as `firebase-service-account.json` in `oauth-test-server/` directory

### 2. Flutter App Configuration

Your Flutter app already has Firebase configured. Make sure these files exist:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## 🚀 Quick Start

### 1. Start the Firebase Backend

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

### 3. Run Flutter App

Your Flutter app is already configured to use Firebase Authentication.

## 📱 Flutter App Testing

### Google Sign-In Testing

1. **Tap "Proceed with Google"**
2. **Google Sign-In popup appears**
3. **Select your Google account**
4. **Grant permissions**
5. **Check for success message**

**Expected Flow**:

- Loading state: "Signing in..."
- Google Sign-In popup appears
- Firebase authentication completes
- Backend receives Firebase user data
- Success message: "Google Sign-In successful!"

### Apple Sign-In Testing (iOS Only)

1. **Tap "Proceed with Apple"**
2. **Apple Sign-In popup appears**
3. **Complete Apple authentication**
4. **Check for success message**

**Expected Flow**:

- Loading state: "Signing in..."
- Apple Sign-In popup appears
- Firebase authentication completes
- Backend receives Firebase user data
- Success message: "Apple Sign-In successful!"

## 🔧 Backend Testing

### 1. Health Check

```bash
curl http://localhost:3000/health
```

### 2. View All Users

```bash
curl http://localhost:3000/api/v1/users
```

### 3. Test Firebase Token Endpoint

```bash
curl -X POST http://localhost:3000/api/v1/auth/firebase-token \
  -H "Content-Type: application/json" \
  -d '{
    "uid": "test-firebase-uid",
    "email": "test@example.com",
    "displayName": "Test User",
    "photoURL": "https://example.com/photo.jpg"
  }'
```

### 4. Test Token Verification

```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-token \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "your-firebase-id-token"
  }'
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Firebase Service Account Error

**Error**: `Firebase service account key not found!`

**Solution**:

```bash
# Download service account key from Firebase Console
# Save as firebase-service-account.json in oauth-test-server/
ls oauth-test-server/firebase-service-account.json
```

#### 2. Google Sign-In Not Working

**Error**: `Google sign-in failed` or popup doesn't appear

**Solutions**:

- Check Firebase Console > Authentication > Sign-in method > Google is enabled
- Verify SHA-1 fingerprint is added to Firebase project
- Test on a real device (not emulator)
- Check Google OAuth consent screen is configured

#### 3. Apple Sign-In Not Working

**Error**: `Apple Sign-In is not available`

**Solutions**:

- Apple Sign-In only works on iOS 13+ devices
- Test on a real iOS device
- Verify Apple Sign-In is enabled in Firebase Console
- Check Apple Developer account configuration

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

# Check server logs
tail -f oauth-test-server/logs/server.log
```

## 📊 Monitoring

### Server Logs

The server logs all Firebase authentication attempts:

```
New Firebase user created: user@example.com
Existing Firebase user logged in: user@example.com
Firebase token generated for: user@example.com
```

### User Management

Check registered users:

```bash
curl http://localhost:3000/api/v1/users | jq
```

### Firebase Console

Monitor authentication in Firebase Console:

1. Go to Firebase Console > Authentication
2. Check "Users" tab for registered users
3. Check "Sign-in method" for enabled providers

## 🔒 Security Notes

### For Testing Only

This setup is designed for development and testing. For production:

1. **Use HTTPS**: Always use HTTPS in production
2. **Environment Variables**: Store secrets in environment variables
3. **Database**: Use Firestore or another database instead of in-memory storage
4. **Firebase Security Rules**: Configure proper security rules
5. **Rate Limiting**: Add rate limiting and security middleware

### Production Checklist

- [ ] Use environment variables for secrets
- [ ] Configure Firebase Security Rules
- [ ] Use Firestore for user data
- [ ] Add rate limiting
- [ ] Use HTTPS
- [ ] Implement proper error handling
- [ ] Add logging and monitoring
- [ ] Test with real OAuth providers

## 🎯 Success Criteria

Your Firebase implementation is working correctly if:

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

## 📞 Support

If you encounter issues:

1. Check the server logs for error messages
2. Verify Firebase project configuration
3. Ensure service account key is properly placed
4. Test with the provided curl commands
5. Check Firebase Console for authentication status
6. Review the troubleshooting section above

## 🔗 Useful Links

- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Firebase Admin SDK](https://firebase.google.com/docs/admin)
- [Flutter Firebase Auth](https://firebase.flutter.dev/docs/auth/overview/)
- [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- [Apple Sign-In Flutter](https://pub.dev/packages/sign_in_with_apple)
