const express = require("express")
const { body, validationResult } = require("express-validator")
const { OAuth2Client } = require("google-auth-library")
const appleSignin = require("apple-signin-auth")
const User = require("../models/User")
const { generateToken } = require("../middleware/auth")

const router = express.Router()

// Google OAuth verification
const verifyGoogleToken = async (idToken) => {
  try {
    const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID)

    const ticket = await client.verifyIdToken({
      idToken: idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    })

    const payload = ticket.getPayload()

    if (!payload) {
      throw new Error("Invalid Google token")
    }

    return {
      providerId: payload.sub,
      email: payload.email,
      firstName: payload.given_name || "",
      lastName: payload.family_name || "",
      displayName: payload.name || "",
      profilePicture: payload.picture || "",
      emailVerified: payload.email_verified || false,
    }
  } catch (error) {
    console.error("Google token verification failed:", error)
    throw new Error("Google token verification failed")
  }
}

// Apple OAuth verification
const verifyAppleToken = async (identityToken, userInfo = {}) => {
  try {
    const clientId = process.env.APPLE_CLIENT_ID

    const payload = await appleSignin.verifyIdToken(identityToken, {
      audience: clientId,
      ignoreExpiration: false,
    })

    if (!payload) {
      throw new Error("Invalid Apple token")
    }

    return {
      providerId: payload.sub,
      email: payload.email || userInfo.email || "",
      firstName: userInfo.firstName || "",
      lastName: userInfo.lastName || "",
      displayName: userInfo.displayName || "",
      profilePicture: "",
      emailVerified: payload.email_verified || false,
    }
  } catch (error) {
    console.error("Apple token verification failed:", error)
    throw new Error("Apple token verification failed")
  }
}

// Find or create user
const findOrCreateUser = async (providerData, provider) => {
  try {
    // First, try to find existing user by provider and providerId
    let user = await User.findByProvider(provider, providerData.providerId)

    if (user) {
      // Update login info
      await user.updateLoginInfo()
      return user
    }

    // If not found, try to find by email (in case user signed in with different provider)
    if (providerData.email) {
      user = await User.findByEmail(providerData.email)

      if (user) {
        // Link the new provider to existing user
        user.provider = provider
        user.providerId = providerData.providerId
        await user.updateLoginInfo()
        return user
      }
    }

    // Create new user
    const newUser = new User({
      provider,
      providerId: providerData.providerId,
      email: providerData.email,
      firstName: providerData.firstName,
      lastName: providerData.lastName,
      displayName: providerData.displayName,
      profilePicture: providerData.profilePicture,
      isEmailVerified: providerData.emailVerified,
      lastLoginAt: new Date(),
      loginCount: 1,
    })

    await newUser.save()
    return newUser
  } catch (error) {
    console.error("Error finding/creating user:", error)
    throw error
  }
}

// Google Sign-In endpoint
router.post(
  "/google",
  [
    body("idToken").notEmpty().withMessage("Google ID token is required"),
    body("deviceInfo").optional().isObject(),
  ],
  async (req, res) => {
    try {
      // Validate request
      const errors = validationResult(req)
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: {
            message: "Validation failed",
            details: errors.array(),
          },
        })
      }

      const { idToken, deviceInfo } = req.body

      // Verify Google token
      const googleData = await verifyGoogleToken(idToken)

      // Find or create user
      const user = await findOrCreateUser(googleData, "google")

      // Generate JWT token
      const token = generateToken(user)

      // Update device info if provided
      if (deviceInfo) {
        user.deviceInfo = deviceInfo
        await user.save()
      }

      res.json({
        success: true,
        data: {
          token,
          user: {
            id: user.userId,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            displayName: user.displayName,
            profilePicture: user.profilePicture,
            provider: user.provider,
            isEmailVerified: user.isEmailVerified,
            lastLoginAt: user.lastLoginAt,
            loginCount: user.loginCount,
          },
        },
      })
    } catch (error) {
      console.error("Google sign-in error:", error)
      res.status(400).json({
        success: false,
        error: {
          message: error.message || "Google sign-in failed",
          status: 400,
        },
      })
    }
  }
)

// Apple Sign-In endpoint
router.post(
  "/apple",
  [
    body("identityToken")
      .notEmpty()
      .withMessage("Apple identity token is required"),
    body("userInfo").optional().isObject(),
    body("deviceInfo").optional().isObject(),
  ],
  async (req, res) => {
    try {
      // Validate request
      const errors = validationResult(req)
      if (!errors.isEmpty()) {
        return res.status(400).json({
          success: false,
          error: {
            message: "Validation failed",
            details: errors.array(),
          },
        })
      }

      const { identityToken, userInfo = {}, deviceInfo } = req.body

      // Verify Apple token
      const appleData = await verifyAppleToken(identityToken, userInfo)

      // Find or create user
      const user = await findOrCreateUser(appleData, "apple")

      // Generate JWT token
      const token = generateToken(user)

      // Update device info if provided
      if (deviceInfo) {
        user.deviceInfo = deviceInfo
        await user.save()
      }

      res.json({
        success: true,
        data: {
          token,
          user: {
            id: user.userId,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            displayName: user.displayName,
            profilePicture: user.profilePicture,
            provider: user.provider,
            isEmailVerified: user.isEmailVerified,
            lastLoginAt: user.lastLoginAt,
            loginCount: user.loginCount,
          },
        },
      })
    } catch (error) {
      console.error("Apple sign-in error:", error)
      res.status(400).json({
        success: false,
        error: {
          message: error.message || "Apple sign-in failed",
          status: 400,
        },
      })
    }
  }
)

// Refresh token endpoint
router.post(
  "/refresh",
  [body("token").notEmpty().withMessage("Token is required")],
  async (req, res) => {
    try {
      const { token } = req.body

      // Verify current token
      const jwt = require("jsonwebtoken")
      const decoded = jwt.verify(token, process.env.JWT_SECRET)

      // Find user
      const user = await User.findById(decoded.userId)

      if (!user || !user.isActive) {
        return res.status(401).json({
          success: false,
          error: {
            message: "Invalid or expired token",
            status: 401,
          },
        })
      }

      // Generate new token
      const newToken = generateToken(user)

      res.json({
        success: true,
        data: {
          token: newToken,
          user: {
            id: user.userId,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            displayName: user.displayName,
            profilePicture: user.profilePicture,
            provider: user.provider,
            isEmailVerified: user.isEmailVerified,
            lastLoginAt: user.lastLoginAt,
            loginCount: user.loginCount,
          },
        },
      })
    } catch (error) {
      console.error("Token refresh error:", error)
      res.status(401).json({
        success: false,
        error: {
          message: "Token refresh failed",
          status: 401,
        },
      })
    }
  }
)

// Logout endpoint
router.post("/logout", async (req, res) => {
  try {
    // In a stateless JWT system, logout is handled client-side
    // You could implement token blacklisting here if needed

    res.json({
      success: true,
      message: "Logged out successfully",
    })
  } catch (error) {
    console.error("Logout error:", error)
    res.status(500).json({
      success: false,
      error: {
        message: "Logout failed",
        status: 500,
      },
    })
  }
})

module.exports = router

