const request = require("supertest")
const app = require("../server")

describe("OAuth Backend Server", () => {
  describe("Health Check", () => {
    it("should return health status", async () => {
      const response = await request(app).get("/health").expect(200)

      expect(response.body.status).toBe("OK")
      expect(response.body.timestamp).toBeDefined()
      expect(response.body.uptime).toBeDefined()
      expect(response.body.environment).toBeDefined()
    })
  })

  describe("Root Endpoint", () => {
    it("should return API information", async () => {
      const response = await request(app).get("/").expect(200)

      expect(response.body.message).toBe("Trakli OAuth Backend Server")
      expect(response.body.version).toBe("1.0.0")
      expect(response.body.endpoints).toBeDefined()
    })
  })

  describe("404 Handler", () => {
    it("should return 404 for non-existent endpoints", async () => {
      const response = await request(app)
        .get("/non-existent-endpoint")
        .expect(404)

      expect(response.body.error).toBe("Endpoint not found")
      expect(response.body.message).toBe("Cannot GET /non-existent-endpoint")
    })
  })

  describe("CORS", () => {
    it("should include CORS headers", async () => {
      const response = await request(app).get("/health").expect(200)

      expect(response.headers["access-control-allow-origin"]).toBeDefined()
    })
  })
})

