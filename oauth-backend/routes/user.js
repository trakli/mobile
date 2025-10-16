const express = require("express")
const { body, validationResult } = require("express-validator")
const { authenticateToken } = require("../middleware/auth")
const User = require("../models/User")

const router = express.Router()

// Get current user profile
router.get("/profile", authenticateToken, async (req, res) => {
  try {
    const user = req.user

    res.json({
      success: true,
      data: {
        user: {
          id: user.userId,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          displayName: user.displayName,
          profilePicture: user.profilePicture,
          provider: user.provider,
          isEmailVerified: user.isEmailVerified,
          isActive: user.isActive,
          lastLoginAt: user.lastLoginAt,
          loginCount: user.loginCount,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
          deviceInfo: user.deviceInfo,
        },
      },
    })
  } catch (error) {
    console.error("Get profile error:", error)
    res.status(500).json({
      success: false,
      error: {
        message: "Failed to get user profile",
        status: 500,
      },
    })
  }
})

// Update user profile
router.put(
  "/profile",
  [
    authenticateToken,
    body("firstName")
      .optional()
      .isLength({ min: 1, max: 50 })
      .withMessage("First name must be between 1 and 50 characters"),
    body("lastName")
      .optional()
      .isLength({ min: 1, max: 50 })
      .withMessage("Last name must be between 1 and 50 characters"),
    body("displayName")
      .optional()
      .isLength({ max: 100 })
      .withMessage("Display name must be less than 100 characters"),
  ],
  async (req, res) => {
    try {
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

      const { firstName, lastName, displayName } = req.body
      const user = req.user

      // Update user fields
      if (firstName !== undefined) user.firstName = firstName
      if (lastName !== undefined) user.lastName = lastName
      if (displayName !== undefined) user.displayName = displayName

      await user.save()

      res.json({
        success: true,
        data: {
          user: {
            id: user.userId,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            displayName: user.displayName,
            profilePicture: user.profilePicture,
            provider: user.provider,
            isEmailVerified: user.isEmailVerified,
            isActive: user.isActive,
            lastLoginAt: user.lastLoginAt,
            loginCount: user.loginCount,
            updatedAt: user.updatedAt,
          },
        },
      })
    } catch (error) {
      console.error("Update profile error:", error)
      res.status(500).json({
        success: false,
        error: {
          message: "Failed to update profile",
          status: 500,
        },
      })
    }
  }
)

// Update device information
router.put(
  "/device",
  [
    authenticateToken,
    body("deviceInfo").isObject().withMessage("Device info must be an object"),
    body("deviceInfo.deviceId").optional().isString(),
    body("deviceInfo.deviceType").optional().isString(),
    body("deviceInfo.appVersion").optional().isString(),
    body("deviceInfo.osVersion").optional().isString(),
  ],
  async (req, res) => {
    try {
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

      const { deviceInfo } = req.body
      const user = req.user

      user.deviceInfo = deviceInfo
      await user.save()

      res.json({
        success: true,
        message: "Device information updated successfully",
        data: {
          deviceInfo: user.deviceInfo,
        },
      })
    } catch (error) {
      console.error("Update device info error:", error)
      res.status(500).json({
        success: false,
        error: {
          message: "Failed to update device information",
          status: 500,
        },
      })
    }
  }
)

// Deactivate account
router.delete("/account", authenticateToken, async (req, res) => {
  try {
    const user = req.user

    // Deactivate user account
    await user.deactivate()

    res.json({
      success: true,
      message: "Account deactivated successfully",
    })
  } catch (error) {
    console.error("Deactivate account error:", error)
    res.status(500).json({
      success: false,
      error: {
        message: "Failed to deactivate account",
        status: 500,
      },
    })
  }
})

// Get user statistics
router.get("/stats", authenticateToken, async (req, res) => {
  try {
    const user = req.user

    // Calculate account age
    const accountAge = Math.floor(
      (Date.now() - user.createdAt.getTime()) / (1000 * 60 * 60 * 24)
    )

    res.json({
      success: true,
      data: {
        stats: {
          accountAge: accountAge,
          loginCount: user.loginCount,
          lastLoginAt: user.lastLoginAt,
          isActive: user.isActive,
          provider: user.provider,
          isEmailVerified: user.isEmailVerified,
        },
      },
    })
  } catch (error) {
    console.error("Get user stats error:", error)
    res.status(500).json({
      success: false,
      error: {
        message: "Failed to get user statistics",
        status: 500,
      },
    })
  }
})

// Check if user exists by email (public endpoint)
router.get("/check-email/:email", async (req, res) => {
  try {
    const { email } = req.params

    if (!email || !email.includes("@")) {
      return res.status(400).json({
        success: false,
        error: {
          message: "Valid email is required",
          status: 400,
        },
      })
    }

    const user = await User.findByEmail(email)

    res.json({
      success: true,
      data: {
        exists: !!user,
        provider: user?.provider || null,
      },
    })
  } catch (error) {
    console.error("Check email error:", error)
    res.status(500).json({
      success: false,
      error: {
        message: "Failed to check email",
        status: 500,
      },
    })
  }
})

module.exports = router

