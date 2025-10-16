#!/usr/bin/env node

const express = require("express")
const cors = require("cors")

// Simple demo server to test the integration
const app = express()
const PORT = 3000

// Middleware
app.use(cors())
app.use(express.json())

// Mock endpoints for testing
app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: "demo",
  })
})

app.get("/", (req, res) => {
  res.json({
    message: "Trakli OAuth Backend Server (Demo)",
    version: "1.0.0",
    endpoints: {
      health: "/health",
      auth: "/api/auth",
      user: "/api/user",
    },
  })
})

// Mock Google OAuth endpoint
app.post("/api/auth/google", (req, res) => {
  console.log("📱 Google OAuth Request:", req.body)

  const { idToken, deviceInfo } = req.body

  if (!idToken) {
    return res.status(400).json({
      success: false,
      error: {
        message: "Google ID token is required",
        status: 400,
      },
    })
  }

  // Mock successful response
  res.json({
    success: true,
    data: {
      token: "mock-jwt-token-" + Date.now(),
      user: {
        id: "12345",
        email: "user@example.com",
        firstName: "John",
        lastName: "Doe",
        displayName: "John Doe",
        profilePicture: "https://example.com/avatar.jpg",
        provider: "google",
        isEmailVerified: true,
        lastLoginAt: new Date().toISOString(),
        loginCount: 1,
      },
    },
  })
})

// Mock Apple OAuth endpoint
app.post("/api/auth/apple", (req, res) => {
  console.log("🍎 Apple OAuth Request:", req.body)

  const { identityToken, userInfo, deviceInfo } = req.body

  if (!identityToken) {
    return res.status(400).json({
      success: false,
      error: {
        message: "Apple identity token is required",
        status: 400,
      },
    })
  }

  // Mock successful response
  res.json({
    success: true,
    data: {
      token: "mock-jwt-token-" + Date.now(),
      user: {
        id: "67890",
        email: userInfo?.email || "user@privaterelay.appleid.com",
        firstName: userInfo?.firstName || "Apple",
        lastName: userInfo?.lastName || "User",
        displayName:
          userInfo?.firstName && userInfo?.lastName
            ? `${userInfo.firstName} ${userInfo.lastName}`
            : "Apple User",
        profilePicture: "",
        provider: "apple",
        isEmailVerified: true,
        lastLoginAt: new Date().toISOString(),
        loginCount: 1,
      },
    },
  })
})

// Mock user profile endpoint
app.get("/api/user/profile", (req, res) => {
  console.log("👤 User Profile Request")

  res.json({
    success: true,
    data: {
      user: {
        id: "12345",
        email: "user@example.com",
        firstName: "John",
        lastName: "Doe",
        displayName: "John Doe",
        profilePicture: "https://example.com/avatar.jpg",
        provider: "google",
        isEmailVerified: true,
        isActive: true,
        lastLoginAt: new Date().toISOString(),
        loginCount: 1,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        deviceInfo: {
          deviceId: "test-device-123",
          deviceType: "iOS",
          appVersion: "1.0.0",
          osVersion: "iOS 17.0",
        },
      },
    },
  })
})

// Mock logout endpoint
app.post("/api/auth/logout", (req, res) => {
  console.log("🚪 Logout Request")

  res.json({
    success: true,
    message: "Logged out successfully",
  })
})

// Start server
app.listen(PORT, () => {
  console.log("🚀 Trakli OAuth Backend Demo Server running on port", PORT)
  console.log("📊 Environment: demo")
  console.log("🔗 Health check: http://localhost:" + PORT + "/health")
  console.log("📚 API Documentation: http://localhost:" + PORT + "/")
  console.log("")
  console.log("🧪 Test the integration:")
  console.log("curl http://localhost:" + PORT + "/health")
  console.log("")
  console.log("📱 Flutter app can now connect to: http://localhost:" + PORT)
})

