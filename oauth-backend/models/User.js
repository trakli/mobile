const mongoose = require("mongoose")

const userSchema = new mongoose.Schema(
  {
    // OAuth provider information
    provider: {
      type: String,
      required: true,
      enum: ["google", "apple"],
      index: true,
    },

    // Provider-specific IDs
    providerId: {
      type: String,
      required: true,
      index: true,
    },

    // User information
    email: {
      type: String,
      required: true,
      lowercase: true,
      trim: true,
      index: true,
    },

    firstName: {
      type: String,
      required: true,
      trim: true,
    },

    lastName: {
      type: String,
      required: true,
      trim: true,
    },

    displayName: {
      type: String,
      trim: true,
    },

    profilePicture: {
      type: String,
      trim: true,
    },

    // Account status
    isActive: {
      type: Boolean,
      default: true,
    },

    isEmailVerified: {
      type: Boolean,
      default: false,
    },

    // Last login information
    lastLoginAt: {
      type: Date,
      default: Date.now,
    },

    // Login count
    loginCount: {
      type: Number,
      default: 1,
    },

    // Device information (optional)
    deviceInfo: {
      deviceId: String,
      deviceType: String,
      appVersion: String,
      osVersion: String,
    },

    // Metadata
    metadata: {
      type: Map,
      of: mongoose.Schema.Types.Mixed,
    },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  }
)

// Indexes for better performance
userSchema.index({ provider: 1, providerId: 1 }, { unique: true })
userSchema.index({ email: 1 })
userSchema.index({ createdAt: -1 })
userSchema.index({ lastLoginAt: -1 })

// Virtual for full name
userSchema.virtual("fullName").get(function () {
  return `${this.firstName} ${this.lastName}`.trim()
})

// Virtual for user ID (for API responses)
userSchema.virtual("userId").get(function () {
  return this._id.toString()
})

// Method to update login information
userSchema.methods.updateLoginInfo = function (deviceInfo = null) {
  this.lastLoginAt = new Date()
  this.loginCount += 1

  if (deviceInfo) {
    this.deviceInfo = deviceInfo
  }

  return this.save()
}

// Method to deactivate account
userSchema.methods.deactivate = function () {
  this.isActive = false
  return this.save()
}

// Static method to find user by provider and ID
userSchema.statics.findByProvider = function (provider, providerId) {
  return this.findOne({ provider, providerId })
}

// Static method to find user by email
userSchema.statics.findByEmail = function (email) {
  return this.findOne({ email: email.toLowerCase() })
}

// Pre-save middleware
userSchema.pre("save", function (next) {
  // Ensure email is lowercase
  if (this.email) {
    this.email = this.email.toLowerCase()
  }

  // Set display name if not provided
  if (!this.displayName && this.firstName && this.lastName) {
    this.displayName = `${this.firstName} ${this.lastName}`
  }

  next()
})

module.exports = mongoose.model("User", userSchema)

