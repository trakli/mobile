const express = require("express")
const cors = require("cors")
const helmet = require("helmet")
const morgan = require("morgan")
const rateLimit = require("express-rate-limit")
require("dotenv").config()

const authRoutes = require("./routes/auth")
const userRoutes = require("./routes/user")
const { errorHandler } = require("./middleware/errorHandler")
const { connectDatabase } = require("./config/database")

const app = express()
const PORT = process.env.PORT || 3000

// Security middleware
app.use(helmet())

// CORS configuration
const corsOptions = {
  origin: process.env.ALLOWED_ORIGINS?.split(",") || ["http://localhost:3000"],
  credentials: true,
  optionsSuccessStatus: 200,
}
app.use(cors(corsOptions))

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // limit each IP to 100 requests per windowMs
  message: {
    error: "Too many requests from this IP, please try again later.",
  },
})
app.use("/api/", limiter)

// Logging
app.use(morgan("combined"))

// Body parsing middleware
app.use(express.json({ limit: "10mb" }))
app.use(express.urlencoded({ extended: true, limit: "10mb" }))

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || "development",
  })
})

// API routes
app.use("/api/auth", authRoutes)
app.use("/api/user", userRoutes)

// Root endpoint
app.get("/", (req, res) => {
  res.json({
    message: "Trakli OAuth Backend Server",
    version: "1.0.0",
    endpoints: {
      health: "/health",
      auth: "/api/auth",
      user: "/api/user",
    },
  })
})

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({
    error: "Endpoint not found",
    message: `Cannot ${req.method} ${req.originalUrl}`,
  })
})

// Error handling middleware
app.use(errorHandler)

// Start server
const startServer = async () => {
  try {
    // Connect to database if MongoDB URI is provided
    if (process.env.MONGODB_URI) {
      await connectDatabase()
    }

    app.listen(PORT, () => {
      console.log(`🚀 Trakli OAuth Backend Server running on port ${PORT}`)
      console.log(`📊 Environment: ${process.env.NODE_ENV || "development"}`)
      console.log(`🔗 Health check: http://localhost:${PORT}/health`)
      console.log(`📚 API Documentation: http://localhost:${PORT}/`)
    })
  } catch (error) {
    console.error("❌ Failed to start server:", error)
    process.exit(1)
  }
}

// Graceful shutdown
process.on("SIGTERM", () => {
  console.log("🛑 SIGTERM received, shutting down gracefully")
  process.exit(0)
})

process.on("SIGINT", () => {
  console.log("🛑 SIGINT received, shutting down gracefully")
  process.exit(0)
})

startServer()

