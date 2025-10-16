# Trakli OAuth Backend Setup Guide

This guide will help you set up the OAuth backend server for the Trakli mobile application.

## 🚀 Quick Start

### 1. Prerequisites

- Node.js 18.0.0 or higher
- MongoDB (optional, for user persistence)
- Google Cloud Console account
- Apple Developer account

### 2. Installation

```bash
# Navigate to the backend directory
cd oauth-backend

# Install dependencies
npm install

# Copy environment template
cp env.example .env

# Start development server
npm run dev
```

## 🔧 Configuration Steps

### Step 1: Google OAuth Setup

1. **Go to Google Cloud Console**

   - Visit: https://console.cloud.google.com/
   - Create a new project or select existing one

2. **Enable Google+ API**

   - Go to "APIs & Services" > "Library"
   - Search for "Google+ API" and enable it

3. **Create OAuth 2.0 Credentials**

   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth 2.0 Client IDs"
   - Choose "Web application"
   - Add authorized redirect URIs:
     - `http://localhost:3000/api/auth/google/callback`
     - `https://your-domain.com/api/auth/google/callback`

4. **Get Credentials**
   - Copy the Client ID and Client Secret
   - Update your `.env` file:
   ```env
   GOOGLE_CLIENT_ID=your-google-client-id
   GOOGLE_CLIENT_SECRET=your-google-client-secret
   ```

### Step 2: Apple Sign-In Setup

1. **Apple Developer Console**

   - Visit: https://developer.apple.com/
   - Sign in with your Apple Developer account

2. **Create App ID**

   - Go to "Certificates, Identifiers & Profiles"
   - Click "Identifiers" > "+" to create new
   - Choose "App IDs" > "App"
   - Enter description and bundle ID
   - Enable "Sign In with Apple" capability
   - Register the App ID

3. **Create Service ID**

   - Go to "Identifiers" > "+" to create new
   - Choose "Services IDs" > "Services ID"
   - Enter description and identifier
   - Enable "Sign In with Apple"
   - Configure domains and redirect URLs:
     - Primary App ID: Select your App ID
     - Domains: `your-domain.com`
     - Return URLs: `https://your-domain.com/api/auth/apple/callback`

4. **Generate Private Key**

   - Go to "Keys" > "+" to create new
   - Enter key name
   - Enable "Sign In with Apple"
   - Configure: Select your App ID
   - Download the `.p8` key file
   - Note the Key ID

5. **Update Environment**
   ```env
   APPLE_CLIENT_ID=your-service-id
   APPLE_TEAM_ID=your-team-id
   APPLE_KEY_ID=your-key-id
   APPLE_PRIVATE_KEY_PATH=./keys/AuthKey_XXXXXXXXXX.p8
   ```

### Step 3: JWT Configuration

Generate a secure JWT secret:

```bash
# Generate a random secret
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

Update your `.env` file:

```env
JWT_SECRET=your-generated-secret-here
JWT_EXPIRES_IN=7d
```

### Step 4: Database Setup (Optional)

If you want to persist user data:

1. **Install MongoDB**

   ```bash
   # macOS with Homebrew
   brew install mongodb-community

   # Start MongoDB
   brew services start mongodb-community
   ```

2. **Update Environment**
   ```env
   MONGODB_URI=mongodb://localhost:27017/trakli-oauth
   ```

### Step 5: CORS Configuration

Update allowed origins in your `.env`:

```env
ALLOWED_ORIGINS=http://localhost:3000,https://your-app-domain.com
```

## 🧪 Testing the Setup

### 1. Start the Server

```bash
npm run dev
```

You should see:

```
🚀 Trakli OAuth Backend Server running on port 3000
📊 Environment: development
🔗 Health check: http://localhost:3000/health
📚 API Documentation: http://localhost:3000/
```

### 2. Test Health Endpoint

```bash
curl http://localhost:3000/health
```

Expected response:

```json
{
  "status": "OK",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "uptime": 123.456,
  "environment": "development"
}
```

### 3. Test Google OAuth

```bash
curl -X POST http://localhost:3000/api/auth/google \
  -H "Content-Type: application/json" \
  -d '{
    "idToken": "your-google-id-token",
    "deviceInfo": {
      "deviceId": "test-device",
      "deviceType": "mobile",
      "appVersion": "1.0.0",
      "osVersion": "iOS 17.0"
    }
  }'
```

### 4. Test Apple OAuth

```bash
curl -X POST http://localhost:3000/api/auth/apple \
  -H "Content-Type: application/json" \
  -d '{
    "identityToken": "your-apple-identity-token",
    "userInfo": {
      "firstName": "John",
      "lastName": "Doe",
      "email": "john@example.com"
    },
    "deviceInfo": {
      "deviceId": "test-device",
      "deviceType": "mobile",
      "appVersion": "1.0.0",
      "osVersion": "iOS 17.0"
    }
  }'
```

## 🔒 Security Checklist

- [ ] JWT secret is strong and unique
- [ ] Google OAuth credentials are correct
- [ ] Apple Sign-In credentials are correct
- [ ] Private key file is secure and not committed
- [ ] CORS origins are properly configured
- [ ] Rate limiting is enabled
- [ ] Environment variables are not exposed

## 🚀 Production Deployment

### Environment Variables

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

## 🐛 Troubleshooting

### Common Issues

1. **"Invalid Google token"**

   - Verify Google Client ID is correct
   - Ensure the token is from the correct app

2. **"Apple token verification failed"**

   - Check Apple credentials
   - Verify private key file path
   - Ensure Service ID is correct

3. **"JWT verification failed"**

   - Check JWT_SECRET is set
   - Ensure token is not expired

4. **CORS errors**
   - Update ALLOWED_ORIGINS
   - Check if domain is properly configured

### Debug Mode

Enable debug logging:

```env
NODE_ENV=development
DEBUG=*
```

## 📞 Support

If you encounter issues:

1. Check the logs for error messages
2. Verify all environment variables
3. Test with curl commands
4. Check OAuth provider configurations
5. Contact the development team

## 🔄 Integration with Flutter

After setting up the backend, update your Flutter app to use the backend endpoints. See the main README.md for integration examples.

