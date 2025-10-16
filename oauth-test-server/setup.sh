#!/bin/bash

echo "🚀 Setting up OAuth Test Server..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    echo "   Visit: https://nodejs.org/"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ Node.js and npm are installed"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << EOF
PORT=3000
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
FIREBASE_PROJECT_ID=your-firebase-project-id
NODE_ENV=development
EOF
    echo "✅ .env file created"
else
    echo "✅ .env file already exists"
fi

# Check for Firebase service account key
if [ ! -f firebase-service-account.json ]; then
    echo "⚠️  Firebase service account key not found!"
    echo "Please download your service account key from Firebase Console:"
    echo "1. Go to Firebase Console > Project Settings"
    echo "2. Go to 'Service accounts' tab"
    echo "3. Click 'Generate new private key'"
    echo "4. Download the JSON file"
    echo "5. Save it as 'firebase-service-account.json' in this directory"
    echo ""
    echo "See FIREBASE_SETUP.md for detailed instructions"
else
    echo "✅ Firebase service account key found"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "To start the server:"
echo "  npm run dev    # Development mode with auto-restart"
echo "  npm start      # Production mode"
echo ""
echo "Server will be available at:"
echo "  http://localhost:3000"
echo ""
echo "API Endpoints:"
echo "  GET  /health                           # Health check"
echo "  GET  /api/v1/users                     # Get all users"
echo "  POST /api/v1/auth/firebase-token       # Firebase token endpoint"
echo "  POST /api/v1/auth/verify-token         # Verify Firebase token"
echo "  POST /api/v1/auth/custom-token         # Create custom token"
echo ""
echo "Next steps:"
echo "1. Update your Flutter app to use http://localhost:3000 as base URL"
echo "2. Start the server: npm run dev"
echo "3. Test the OAuth flow in your Flutter app"
