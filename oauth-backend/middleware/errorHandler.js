const errorHandler = (err, req, res, next) => {
  console.error("Error:", err)

  // Default error
  let error = {
    message: err.message || "Internal Server Error",
    status: err.status || 500,
  }

  // Mongoose validation error
  if (err.name === "ValidationError") {
    const messages = Object.values(err.errors).map((val) => val.message)
    error = {
      message: "Validation Error",
      status: 400,
      details: messages,
    }
  }

  // Mongoose duplicate key error
  if (err.code === 11000) {
    const field = Object.keys(err.keyValue)[0]
    error = {
      message: `${field} already exists`,
      status: 400,
    }
  }

  // JWT errors
  if (err.name === "JsonWebTokenError") {
    error = {
      message: "Invalid token",
      status: 401,
    }
  }

  if (err.name === "TokenExpiredError") {
    error = {
      message: "Token expired",
      status: 401,
    }
  }

  // Rate limit error
  if (err.status === 429) {
    error = {
      message: "Too many requests",
      status: 429,
    }
  }

  // Send error response
  res.status(error.status).json({
    success: false,
    error: {
      message: error.message,
      status: error.status,
      ...(error.details && { details: error.details }),
      ...(process.env.NODE_ENV === "development" && { stack: err.stack }),
    },
    timestamp: new Date().toISOString(),
  })
}

module.exports = { errorHandler }

