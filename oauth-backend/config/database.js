const mongoose = require("mongoose")

const connectDatabase = async () => {
  try {
    const mongoUri = process.env.MONGODB_URI

    if (!mongoUri) {
      console.log("⚠️  No MongoDB URI provided, skipping database connection")
      return
    }

    const options = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      maxPoolSize: 10,
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    }

    await mongoose.connect(mongoUri, options)

    console.log("✅ Connected to MongoDB successfully")

    // Handle connection events
    mongoose.connection.on("error", (err) => {
      console.error("❌ MongoDB connection error:", err)
    })

    mongoose.connection.on("disconnected", () => {
      console.log("⚠️  MongoDB disconnected")
    })

    mongoose.connection.on("reconnected", () => {
      console.log("✅ MongoDB reconnected")
    })
  } catch (error) {
    console.error("❌ MongoDB connection failed:", error)
    throw error
  }
}

module.exports = { connectDatabase }

