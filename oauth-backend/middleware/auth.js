const jwt = require("jsonwebtoken")
const User = require("../models/User")

const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers["authorization"]
    const token = authHeader && authHeader.split(" ")[1] // Bearer TOKEN

    if (!token) {
      return res.status(401).json({
        success: false,
        error: {
          message: "Access token required",
          status: 401,
        },
      })
    }

    // Verify JWT token
    const decoded = jwt.verify(token, process.env.JWT_SECRET)

    // Find user in database
    const user = await User.findById(decoded.userId)

    if (!user) {
      return res.status(401).json({
        success: false,
        error: {
          message: "User not found",
          status: 401,
        },
      })
    }

    if (!user.isActive) {
      return res.status(401).json({
        success: false,
        error: {
          message: "Account is deactivated",
          status: 401,
        },
      })
    }

    // Add user to request object
    req.user = user
    next()
  } catch (error) {
    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({
        success: false,
        error: {
          message: "Invalid token",
          status: 401,
        },
      })
    }

    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        error: {
          message: "Token expired",
          status: 401,
        },
      })
    }

    return res.status(500).json({
      success: false,
      error: {
        message: "Authentication error",
        status: 500,
      },
    })
  }
}

const generateToken = (user) => {
  const payload = {
    userId: user._id,
    email: user.email,
    provider: user.provider,
  }

  return jwt.sign(payload, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || "7d",
  })
}

module.exports = { authenticateToken, generateToken }

