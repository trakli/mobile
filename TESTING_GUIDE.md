# OAuth Testing Guide

This guide will help you test the Google and Apple Sign-In implementation in your Flutter app.

## 🚀 Quick Start

### 1. Start the Test Server

```bash
cd oauth-test-server
chmod +x setup.sh
./setup.sh
npm run dev
```

The server will start on `http://localhost:3000`

### 2. Update Flutter App

The Flutter app is already configured to use the local test server at `http://localhost:3000`.

### 3. Test the Implementation

1. Run your Flutter app
2. Navigate to the login screen
3. Tap "Proceed with Google" or "Proceed with Apple"
4. Complete the OAuth flow
5. Check the server logs for authentication details

## 📱 Flutter App Testing

### Google Sign-In Testing

1. **Tap "Proceed with Google"**
2. **Google Sign-In popup appears**
3. **Select your Google account**
4. **Grant permissions**
5. **Check for success message**

Expected behavior:

- Loading state shows "Signing in..."
- Google Sign-In popup appears
- After successful authentication, shows "Google Sign-In successful!"
- User data is sent to the test server

### Apple Sign-In Testing

1. **Tap "Proceed with Apple"**
2. **Apple Sign-In popup appears**
3. **Complete Apple authentication**
4. **Check for success message**

Expected behavior:

- Loading state shows "Signing in..."
- Apple Sign-In popup appears
- After successful authentication, shows "Apple Sign-In successful!"
- User data is sent to the test server

## 🔧 Server Testing

### Check Server Health

```bash
curl http://localhost:3000/health
```

Expected response:

```json
{
  "success": true,
  "message": "OAuth test server is running",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### View All Users

```bash
curl http://localhost:3000/api/v1/users
```

This will show all users who have signed in through your app.

### Test Google Authentication Endpoint

```bash
curl -X POST http://localhost:3000/api/v1/auth/google \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "test_token",
    "accessToken": "test_access_token",
    "email": "test@example.com",
    "name": "Test User",
    "photoUrl": "https://example.com/photo.jpg"
  }'
```

### Test Apple Authentication Endpoint

```bash
curl -X POST http://localhost:3000/api/v1/auth/apple \
  -H "Content-Type: application/json" \
  -d '{
    "identityToken": "test_identity_token",
    "authorizationCode": "test_auth_code",
    "email": "test@example.com",
    "firstName": "Test",
    "lastName": "User"
  }'
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Server Connection Failed

**Error**: `Connection refused` or `Network error`

**Solution**:

- Make sure the server is running: `npm run dev`
- Check if port 3000 is available
- Verify the server is accessible: `curl http://localhost:3000/health`

#### 2. Google Sign-In Not Working

**Error**: `Google sign-in failed` or popup doesn't appear

**Solutions**:

- Check your Google Client ID in the OAuth service
- Verify SHA-1 fingerprint is added to Google Console
- Make sure Google Sign-In is enabled in your Google project
- Check if the app is running on a real device (not emulator for some features)

#### 3. Apple Sign-In Not Working

**Error**: `Apple Sign-In is not available`

**Solutions**:

- Apple Sign-In only works on iOS 13+ devices
- Make sure you're testing on a real iOS device
- Check if Apple Sign-In capability is enabled in your iOS project
- Verify your Apple Developer account has Sign In with Apple enabled

#### 4. Authentication Fails

**Error**: `Authentication failed` or `Server error`

**Solutions**:

- Check server logs for detailed error messages
- Verify the server is receiving the requests
- Check if the JWT secret is properly configured
- Ensure all required fields are being sent

### Debug Mode

Enable debug logging in the server:

```bash
DEBUG=oauth-test-server npm run dev
```

### Flutter Debug

Add debug prints to your OAuth service:

```dart
print('OAuth request: ${request.body}');
print('OAuth response: ${response.body}');
```

## 📊 Monitoring

### Server Logs

The server logs all authentication attempts:

```
New Google user created: user@example.com
Existing Google user logged in: user@example.com
New Apple user created: user@privaterelay.appleid.com
```

### User Management

Check registered users:

```bash
curl http://localhost:3000/api/v1/users | jq
```

### Health Monitoring

```bash
# Check server status
curl http://localhost:3000/health

# Check if server is responding
curl -I http://localhost:3000/health
```

## 🔒 Security Notes

### For Testing Only

This test server is designed for development and testing only. For production:

1. **Use HTTPS**: Always use HTTPS in production
2. **Environment Variables**: Store secrets in environment variables
3. **Database**: Use a proper database instead of in-memory storage
4. **Token Verification**: Implement proper token verification
5. **Rate Limiting**: Add rate limiting and security middleware
6. **CORS**: Configure CORS properly for your domain

### Production Checklist

- [ ] Use environment variables for secrets
- [ ] Implement proper database storage
- [ ] Add rate limiting
- [ ] Configure CORS for your domain
- [ ] Use HTTPS
- [ ] Implement proper error handling
- [ ] Add logging and monitoring
- [ ] Test with real OAuth providers

## 🎯 Success Criteria

Your implementation is working correctly if:

1. ✅ Server starts without errors
2. ✅ Flutter app connects to server
3. ✅ Google Sign-In popup appears
4. ✅ Apple Sign-In popup appears (on iOS)
5. ✅ Authentication completes successfully
6. ✅ User data is stored on server
7. ✅ Success messages appear in Flutter app
8. ✅ No network errors in logs

## 📞 Support

If you encounter issues:

1. Check the server logs for error messages
2. Verify all dependencies are installed
3. Ensure your Google/Apple OAuth is properly configured
4. Test with the provided curl commands
5. Check the troubleshooting section above
