@testable import Sayar
import XCTest

final class AppConfigTests: XCTestCase {
    func testDefaultAppConfig() {
        let config = AppConfig.default

        // Should read from bundle
        XCTAssertNotNil(config.appName)
        XCTAssertNotNil(config.environment)
        XCTAssertNotNil(config.bundleIdentifier)

        print("✅ Environment: \(config.environment)")
        print("✅ API Base URL: \(config.apiBaseURL)")
        print("✅ Bundle ID: \(config.bundleIdentifier)")
        print("✅ Debug Menu: \(config.enableDebugMenu)")
        print("✅ Logging: \(config.enableLogging)")
    }

    func testCustomAppConfig() {
        let config = AppConfig(
            apiBaseURL: "https://test-api.com",
            environment: "test",
            appName: "Test App",
            enableLogging: true,
            enableDebugMenu: false,
            apiTimeout: 10.0
        )

        XCTAssertEqual(config.apiBaseURL, "https://test-api.com")
        XCTAssertEqual(config.environment, "test")
        XCTAssertEqual(config.appName, "Test App")
        XCTAssertTrue(config.enableLogging)
        XCTAssertFalse(config.enableDebugMenu)
        XCTAssertEqual(config.apiTimeout, 10.0)

        // Environment helpers
        XCTAssertFalse(config.isDevelopment)
        XCTAssertFalse(config.isUAT)
        XCTAssertFalse(config.isProduction)
    }

    func testEnvironmentDetection() {
        let devConfig = AppConfig(environment: "dev")
        XCTAssertTrue(devConfig.isDevelopment)
        XCTAssertFalse(devConfig.isUAT)
        XCTAssertFalse(devConfig.isProduction)

        let uatConfig = AppConfig(environment: "uat")
        XCTAssertFalse(uatConfig.isDevelopment)
        XCTAssertTrue(uatConfig.isUAT)
        XCTAssertFalse(uatConfig.isProduction)

        let prodConfig = AppConfig(environment: "prod")
        XCTAssertFalse(prodConfig.isDevelopment)
        XCTAssertFalse(prodConfig.isUAT)
        XCTAssertTrue(prodConfig.isProduction)
    }

    func testPartialOverride() {
        // Only override API URL, rest from bundle
        let config = AppConfig(apiBaseURL: "https://custom-api.com")

        XCTAssertEqual(config.apiBaseURL, "https://custom-api.com")
        // Other values should come from bundle/defaults
        XCTAssertNotNil(config.environment)
        XCTAssertNotNil(config.appName)
    }
}
