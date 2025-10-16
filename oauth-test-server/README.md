# OAuth Test Server

A Node.js server to test Google and Apple Sign-In authentication with your Flutter app.

## Features

- ✅ Google Sign-In authentication
- ✅ Apple Sign-In authentication
- ✅ JWT token generation
- ✅ User management
- ✅ CORS enabled for Flutter app
- ✅ Health check endpoint

## Setup

### 1. Install Dependencies

```bash
cd oauth-test-server
npm install
```

### 2. Configure Google OAuth

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add your Flutter app's package name and SHA-1 fingerprint
6. Update `GOOGLE_CLIENT_ID` in `server.js`

### 3. Configure Apple Sign-In (Optional)

1. Go to [Apple Developer Console](https://developer.apple.com/)
2. Create an App ID with Sign In with Apple capability
3. Create a Service ID for web authentication
4. Update Apple configuration in `server.js`

### 4. Update Flutter App

Update the base URL in your Flutter app's OAuth service:

```dart
// In lib/core/services/oauth_service.dart
final String _baseUrl = 'http://localhost:3000'; // For local testing
// or
final String _baseUrl = 'https://your-server.com'; // For production
```

## Running the Server

### Development Mode

```bash
npm run dev
```

### Production Mode

```bash
npm start
```

## API Endpoints

### Authentication

- `POST /api/v1/auth/google` - Google Sign-In
- `POST /api/v1/auth/apple` - Apple Sign-In

### OAuth URLs

- `GET /api/v1/oauth/google/login` - Get Google OAuth URL

### Utility

- `GET /health` - Health check
- `GET /api/v1/users` - Get all users (for testing)

## Testing

1. Start the server: `npm run dev`
2. Update your Flutter app to use `http://localhost:3000` as base URL
3. Run your Flutter app
4. Test Google and Apple Sign-In
5. Check users at: `http://localhost:3000/api/v1/users`

## Request Examples

### Google Sign-In Request

```json
POST /api/v1/auth/google
{
  "idToken": "google_id_token_here",
  "accessToken": "google_access_token_here",
  "email": "user@example.com",
  "name": "John Doe",
  "photoUrl": "https://example.com/photo.jpg"
}
```

### Apple Sign-In Request

```json
POST /api/v1/auth/apple
{
  "identityToken": "apple_identity_token_here",
  "authorizationCode": "apple_auth_code_here",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe"
}
```

## Response Format

```json
{
  "success": true,
  "message": "Authentication successful",
  "data": {
    "id": "user_1234567890",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "profilePicture": "https://example.com/photo.jpg",
    "isEmailVerified": true,
    "token": "jwt_token_here"
  }
}
```

## Environment Variables

Create a `.env` file for production:

```env
PORT=3000
JWT_SECRET=your-super-secret-jwt-key
GOOGLE_CLIENT_ID=your-google-client-id
APPLE_CLIENT_ID=com.yourapp.bundleid
APPLE_TEAM_ID=your-apple-team-id
APPLE_KEY_ID=your-apple-key-id
```

## Production Deployment

1. Set up environment variables
2. Use a proper database (PostgreSQL, MongoDB, etc.)
3. Implement proper Apple ID token verification
4. Add rate limiting and security middleware
5. Deploy to your preferred platform (Heroku, AWS, etc.)

## Troubleshooting

### Common Issues

1. **CORS errors**: Make sure CORS is enabled in the server
2. **Google authentication fails**: Check your Google Client ID and SHA-1 fingerprint
3. **Apple authentication fails**: Verify your Apple configuration
4. **Network errors**: Ensure the server is running and accessible

### Debug Mode

Enable debug logging by setting:

```bash
DEBUG=oauth-test-server npm run dev
```
