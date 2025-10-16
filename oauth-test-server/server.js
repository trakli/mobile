const express = require("express")
const cors = require("cors")
const admin = require("firebase-admin")
const jwt = require("jsonwebtoken")

const app = express()
const PORT = process.env.PORT || 3000

// Middleware
app.use(cors())
app.use(express.json())

// Initialize Firebase Admin SDK
// You need to download your service account key from Firebase Console
// and place it in the project root as 'firebase-service-account.json'
let serviceAccount
try {
  serviceAccount = require("./firebase-service-account.json")
} catch (error) {
  console.error("❌ Firebase service account key not found!")
  console.error(
    "Please download your service account key from Firebase Console"
  )
  console.error(
    "and save it as 'firebase-service-account.json' in the project root"
  )
  process.exit(1)
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  // Optional: specify your Firebase project ID
  // projectId: "your-project-id"
})

// JWT secret for custom tokens (in production, use environment variable)
const JWT_SECRET = process.env.JWT_SECRET || "your-jwt-secret-key"

// In-memory user storage (in production, use a database)
const users = new Map()

// Helper function to generate JWT token
function generateJWT(user) {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      name: user.name,
    },
    JWT_SECRET,
    { expiresIn: "7d" }
  )
}

// Helper function to create user response
function createUserResponse(user) {
  return {
    success: true,
    message: "Authentication successful",
    data: {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      profilePicture: user.profilePicture,
      isEmailVerified: user.isEmailVerified,
      token: generateJWT(user),
    },
  }
}

// Firebase user data endpoint - handles authenticated Firebase users
app.post("/api/v1/auth/firebase-user", async (req, res) => {
  try {
    const { uid, email, displayName, photoURL } = req.body

    if (!uid) {
      return res.status(400).json({
        success: false,
        message: "Firebase UID is required",
      })
    }

    // Verify the user exists in Firebase
    let firebaseUser
    try {
      firebaseUser = await admin.auth().getUser(uid)
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: "Invalid Firebase user",
        error: error.message,
      })
    }

    // Check if user exists in our database
    let user = users.get(uid)

    if (!user) {
      // Create new user
      user = {
        id: uid,
        email: firebaseUser.email || email,
        firstName: displayName?.split(" ")[0] || "",
        lastName: displayName?.split(" ").slice(1).join(" ") || "",
        profilePicture: photoURL || firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
        provider: firebaseUser.providerData[0]?.providerId || "unknown",
        createdAt: new Date().toISOString(),
      }

      users.set(uid, user)
      console.log("New Firebase user created:", user.email)
    } else {
      // Update existing user
      user.profilePicture = photoURL || firebaseUser.photoURL
      user.lastLoginAt = new Date().toISOString()
      users.set(uid, user)
      console.log("Existing Firebase user logged in:", user.email)
    }

    res.json(createUserResponse(user))
  } catch (error) {
    console.error("Firebase user data error:", error)
    res.status(500).json({
      success: false,
      message: "Firebase user data processing failed",
      error: error.message,
    })
  }
})

// curl -X 'POST' \
//   'https://2aef8611a04e.ngrok-free.app/api/v1/auth/verify-token' \
//   -H 'accept: */*' \
//   -H 'Content-Type: application/json' \
//   -d '{
//   "email": "user@example.com",
//   "phone": "string",
//   "username": "string",
//   "password": "string"
// }'

// Verify Firebase ID token endpoint
app.post("/api/v1/auth/verify-token", async (req, res) => {
  try {
    const { idToken } = req.body

    if (!idToken) {
      return res.status(400).json({
        success: false,
        message: "ID token is required",
      })
    }

    // Verify the Firebase ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken)

    const uid = decodedToken.uid
    const fullName = decodedToken.name
    const email = decodedToken.email

    console.log("Decoded token:", decodedToken)

    // Get user from our database
    const user = {
      id: uid,
      email: email,
      firstName: fullName,
      provider: decodedToken.provider,
    }

    res.json(createUserResponse(user))
  } catch (error) {
    console.error("Token verification error:", error)
    res.status(400).json({
      success: false,
      message: "Token verification failed",
      error: error.message,
    })
  }
})

// Create custom token endpoint (for server-to-server authentication)
app.post("/api/v1/auth/custom-token", async (req, res) => {
  try {
    const { uid, additionalClaims } = req.body

    if (!uid) {
      return res.status(400).json({
        success: false,
        message: "UID is required",
      })
    }

    // Create custom token
    const customToken = await admin
      .auth()
      .createCustomToken(uid, additionalClaims)

    res.json({
      success: true,
      message: "Custom token created",
      data: {
        customToken,
      },
    })
  } catch (error) {
    console.error("Custom token creation error:", error)
    res.status(500).json({
      success: false,
      message: "Custom token creation failed",
      error: error.message,
    })
  }
})

// Health check endpoint
app.get("/health", (req, res) => {
  res.json({
    success: true,
    message: "Firebase OAuth server is running",
    timestamp: new Date().toISOString(),
    firebase: "connected",
  })
})

// Get all users endpoint (for testing)
app.get("/api/v1/users", (req, res) => {
  const userList = Array.from(users.values())
  res.json({
    success: true,
    data: userList,
    count: userList.length,
  })
})

// Get user by UID endpoint
app.get("/api/v1/users/:uid", async (req, res) => {
  try {
    const { uid } = req.params
    const user = users.get(uid)

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    res.json({
      success: true,
      data: user,
    })
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error fetching user",
      error: error.message,
    })
  }
})

// Delete user endpoint (for testing)
app.delete("/api/v1/users/:uid", async (req, res) => {
  try {
    const { uid } = req.params
    const deleted = users.delete(uid)

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    res.json({
      success: true,
      message: "User deleted successfully",
    })
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Error deleting user",
      error: error.message,
    })
  }
})

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Firebase OAuth server running on port ${PORT}`)
  console.log(`📱 Health check: http://localhost:${PORT}/health`)
  console.log(`👥 Users endpoint: http://localhost:${PORT}/api/v1/users`)
  console.log(
    `🔐 Firebase token: http://localhost:${PORT}/api/v1/auth/firebase-token`
  )
  console.log(
    `✅ Token verify: http://localhost:${PORT}/api/v1/auth/verify-token`
  )
  console.log(
    `🎫 Custom token: http://localhost:${PORT}/api/v1/auth/custom-token`
  )
})
