const axios = require("axios")

// Test configuration
const BASE_URL = "http://localhost:3000/api"

// Test data
const testGoogleToken = "mock-google-id-token"
const testAppleToken = "mock-apple-identity-token"

async function testBackendIntegration() {
  console.log("🧪 Testing OAuth Backend Integration\n")

  try {
    // Test 1: Health Check
    console.log("1️⃣ Testing Health Check...")
    const healthResponse = await axios.get("http://localhost:3000/health")
    console.log("✅ Health Check:", healthResponse.data)
    console.log("")

    // Test 2: Google OAuth (Mock)
    console.log("2️⃣ Testing Google OAuth...")
    try {
      const googleResponse = await axios.post(`${BASE_URL}/auth/google`, {
        idToken: testGoogleToken,
        deviceInfo: {
          deviceId: "test-device-123",
          deviceType: "iOS",
          appVersion: "1.0.0",
          osVersion: "iOS 17.0",
        },
      })
      console.log("✅ Google OAuth Response:", googleResponse.data)
    } catch (error) {
      console.log(
        "⚠️ Google OAuth Error (Expected - Mock Token):",
        error.response?.data || error.message
      )
    }
    console.log("")

    // Test 3: Apple OAuth (Mock)
    console.log("3️⃣ Testing Apple OAuth...")
    try {
      const appleResponse = await axios.post(`${BASE_URL}/auth/apple`, {
        identityToken: testAppleToken,
        userInfo: {
          firstName: "John",
          lastName: "Doe",
          email: "john.doe@example.com",
        },
        deviceInfo: {
          deviceId: "test-device-456",
          deviceType: "iOS",
          appVersion: "1.0.0",
          osVersion: "iOS 17.0",
        },
      })
      console.log("✅ Apple OAuth Response:", appleResponse.data)
    } catch (error) {
      console.log(
        "⚠️ Apple OAuth Error (Expected - Mock Token):",
        error.response?.data || error.message
      )
    }
    console.log("")

    // Test 4: Check Email Endpoint
    console.log("4️⃣ Testing Email Check...")
    try {
      const emailResponse = await axios.get(
        `${BASE_URL}/user/check-email/test@example.com`
      )
      console.log("✅ Email Check Response:", emailResponse.data)
    } catch (error) {
      console.log(
        "❌ Email Check Error:",
        error.response?.data || error.message
      )
    }
    console.log("")

    console.log("🎉 Backend Integration Test Completed!")
    console.log("")
    console.log("📝 Next Steps:")
    console.log("1. Start the backend server: npm run dev")
    console.log("2. Update Flutter app to use the backend API")
    console.log("3. Test with real OAuth tokens from your app")
  } catch (error) {
    console.error("❌ Integration Test Failed:", error.message)
    console.log("")
    console.log("🔧 Troubleshooting:")
    console.log("1. Make sure the backend server is running: npm run dev")
    console.log("2. Check if the server is accessible at http://localhost:3000")
    console.log("3. Verify all dependencies are installed: npm install")
  }
}

// Run the test
testBackendIntegration()

