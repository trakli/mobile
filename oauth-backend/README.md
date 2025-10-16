# Trakli OAuth Backend Server

A comprehensive Node.js backend server for handling Google and Apple Sign-In authentication for the Trakli mobile application.

## 🚀 Features

- **Google OAuth Integration**: Secure Google Sign-In with token verification
- **Apple OAuth Integration**: Apple Sign-In with identity token verification
- **JWT Authentication**: Stateless authentication with JSON Web Tokens
- **User Management**: Complete user profile and account management
- **Database Integration**: MongoDB support for user persistence
- **Security**: Rate limiting, CORS, helmet security headers
- **Error Handling**: Comprehensive error handling and logging
- **API Documentation**: Well-documented REST API endpoints

## 📋 Prerequisites

- Node.js 18.0.0 or higher
- MongoDB (optional, for user persistence)
- Google OAuth credentials
- Apple Sign-In credentials

## 🛠️ Installation

1. **Clone and navigate to the backend directory:**

   ```bash
   cd oauth-backend
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Set up environment variables:**

   ```bash
   cp env.example .env
   ```

   Edit `.env` file with your configuration:

   ```env
   # Server Configuration
   PORT=3000
   NODE_ENV=development

   # JWT Configuration
   JWT_SECRET=your-super-secret-jwt-key-here
   JWT_EXPIRES_IN=7d

   # Google OAuth Configuration
   GOOGLE_CLIENT_ID=your-google-client-id
   GOOGLE_CLIENT_SECRET=your-google-client-secret

   # Apple OAuth Configuration
   APPLE_CLIENT_ID=your-apple-client-id
   APPLE_TEAM_ID=your-apple-team-id
   APPLE_KEY_ID=your-apple-key-id
   APPLE_PRIVATE_KEY_PATH=./keys/AuthKey_XXXXXXXXXX.p8

   # Database Configuration (Optional)
   MONGODB_URI=mongodb://localhost:27017/trakli-oauth

   # CORS Configuration
   ALLOWED_ORIGINS=http://localhost:3000,https://your-app-domain.com
   ```

4. **Start the server:**

   ```bash
   # Development mode
   npm run dev

   # Production mode
   npm start
   ```

## 🔧 Configuration

### Google OAuth Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add your app's bundle ID and redirect URIs
6. Copy Client ID and Client Secret to `.env`

### Apple Sign-In Setup

1. Go to [Apple Developer Console](https://developer.apple.com/)
2. Create an App ID with Sign In with Apple capability
3. Create a Service ID for web authentication
4. Generate a private key for Sign In with Apple
5. Download the `.p8` key file and place it in `./keys/` directory
6. Update `.env` with Apple credentials

## 📚 API Endpoints

### Authentication Endpoints

#### Google Sign-In

```http
POST /api/auth/google
Content-Type: application/json

{
  "idToken": "google-id-token",
  "deviceInfo": {
    "deviceId": "device-uuid",
    "deviceType": "mobile",
    "appVersion": "1.0.0",
    "osVersion": "iOS 17.0"
  }
}
```

#### Apple Sign-In

```http
POST /api/auth/apple
Content-Type: application/json

{
  "identityToken": "apple-identity-token",
  "userInfo": {
    "firstName": "John",
    "lastName": "Doe",
    "email": "john@example.com"
  },
  "deviceInfo": {
    "deviceId": "device-uuid",
    "deviceType": "mobile",
    "appVersion": "1.0.0",
    "osVersion": "iOS 17.0"
  }
}
```

#### Refresh Token

```http
POST /api/auth/refresh
Content-Type: application/json

{
  "token": "jwt-token"
}
```

#### Logout

```http
POST /api/auth/logout
```

### User Management Endpoints

#### Get User Profile

```http
GET /api/user/profile
Authorization: Bearer jwt-token
```

#### Update User Profile

```http
PUT /api/user/profile
Authorization: Bearer jwt-token
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "displayName": "John Doe"
}
```

#### Update Device Information

```http
PUT /api/user/device
Authorization: Bearer jwt-token
Content-Type: application/json

{
  "deviceInfo": {
    "deviceId": "device-uuid",
    "deviceType": "mobile",
    "appVersion": "1.0.0",
    "osVersion": "iOS 17.0"
  }
}
```

#### Get User Statistics

```http
GET /api/user/stats
Authorization: Bearer jwt-token
```

#### Deactivate Account

```http
DELETE /api/user/account
Authorization: Bearer jwt-token
```

#### Check Email Existence

```http
GET /api/user/check-email/user@example.com
```

## 🔒 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Rate Limiting**: Prevents abuse with configurable rate limits
- **CORS Protection**: Configurable cross-origin resource sharing
- **Helmet Security**: Security headers for protection
- **Input Validation**: Request validation using express-validator
- **Error Handling**: Comprehensive error handling and logging

## 📊 Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    "token": "jwt-token",
    "user": {
      "id": "user-id",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "displayName": "John Doe",
      "profilePicture": "https://...",
      "provider": "google",
      "isEmailVerified": true,
      "lastLoginAt": "2024-01-01T00:00:00.000Z",
      "loginCount": 1
    }
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "message": "Error message",
    "status": 400,
    "details": ["Validation error details"]
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## 🧪 Testing

Run the test suite:

```bash
npm test
```

## 🚀 Deployment

### Environment Variables for Production

```env
NODE_ENV=production
PORT=3000
JWT_SECRET=your-production-jwt-secret
GOOGLE_CLIENT_ID=your-production-google-client-id
GOOGLE_CLIENT_SECRET=your-production-google-client-secret
APPLE_CLIENT_ID=your-production-apple-client-id
APPLE_TEAM_ID=your-production-apple-team-id
APPLE_KEY_ID=your-production-apple-key-id
APPLE_PRIVATE_KEY_PATH=./keys/AuthKey_XXXXXXXXXX.p8
MONGODB_URI=your-production-mongodb-uri
ALLOWED_ORIGINS=https://your-production-domain.com
```

### Docker Deployment

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## 📝 Integration with Flutter App

### Update OAuth Service

Update your Flutter `OAuthService` to use the backend:

```dart
// Add HTTP client dependency
import 'package:http/http.dart' as http;
import 'dart:convert';

class OAuthService {
  static const String baseUrl = 'https://your-backend-url.com/api';

  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      // ... existing Google sign-in code ...

      // Send to backend for verification
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idToken': googleAuth.idToken,
          'deviceInfo': {
            'deviceId': await getDeviceId(),
            'deviceType': Platform.isIOS ? 'iOS' : 'Android',
            'appVersion': await getAppVersion(),
            'osVersion': await getOSVersion(),
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['data']['token'];
        final userData = data['data']['user'];

        // Store token securely
        await storeToken(token);

        // Create user entity
        final user = UserEntity(
          id: int.tryParse(userData['id']) ?? 0,
          email: userData['email'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
        );

        return Right(user);
      } else {
        return Left(ServerFailure('Backend authentication failed'));
      }
    } catch (e) {
      return Left(ServerFailure('Google sign-in failed: ${e.toString()}'));
    }
  }
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Google OAuth Error**: Verify client ID and ensure it matches your app's bundle ID
2. **Apple Sign-In Error**: Check Apple credentials and ensure the private key is correctly placed
3. **JWT Token Error**: Verify JWT_SECRET is set and consistent
4. **CORS Error**: Update ALLOWED_ORIGINS with your app's domain

### Logs

Check server logs for detailed error information:

```bash
# Development
npm run dev

# Production
npm start
```

## 📄 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📞 Support

For support, please contact the development team or create an issue in the repository.

