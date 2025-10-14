@testable import Sayar
import XCTest

final class ConfigurationTests: XCTestCase {
    func testDevEnvironmentConfiguration() {
        let config = AppConfig.default

        // Print current configuration for verification
        print("=== DEV CONFIGURATION TEST ===")
        config.printCurrentConfig()

        // Basic assertions
        XCTAssertFalse(config.appName.isEmpty)
        XCTAssertFalse(config.bundleIdentifier.isEmpty)
        XCTAssertTrue(config.apiTimeout > 0)

        // Environment-specific checks
        if config.isDevelopment {
            print("✅ Running in DEV environment")
            XCTAssertEqual(config.environment, "dev")
        } else if config.isUAT {
            print("✅ Running in UAT environment")
            XCTAssertEqual(config.environment, "uat")
        } else if config.isProduction {
            print("✅ Running in PROD environment")
            XCTAssertEqual(config.environment, "prod")
        }
    }

    func testBundleIdentifierEnvironmentSpecific() {
        let config = AppConfig.default

        // Check if bundle identifier contains environment info
        print("Bundle Identifier: \(config.bundleIdentifier)")

        if config.isDevelopment {
            // Dev should have .dev suffix or similar
            XCTAssertTrue(
                config.bundleIdentifier.contains("dev") ||
                    config.bundleIdentifier.contains("debug"),
                "DEV environment should have dev/debug in bundle ID"
            )
        } else if config.isUAT {
            XCTAssertTrue(
                config.bundleIdentifier.contains("uat") ||
                    config.bundleIdentifier.contains("staging"),
                "UAT environment should have uat/staging in bundle ID"
            )
        } else if config.isProduction {
            XCTAssertFalse(
                config.bundleIdentifier.contains("dev") ||
                    config.bundleIdentifier.contains("uat") ||
                    config.bundleIdentifier.contains("debug"),
                "PROD environment should not have dev/uat/debug in bundle ID"
            )
        }
    }

    func testAPIBaseURLConfiguration() {
        let config = AppConfig.default

        print("API Base URL: \(config.apiBaseURL)")

        if !config.apiBaseURL.isEmpty {
            // Should be a valid URL format
            XCTAssertTrue(
                config.apiBaseURL.hasPrefix("http://") ||
                    config.apiBaseURL.hasPrefix("https://"),
                "API Base URL should be a valid HTTP(S) URL"
            )

            // Environment-specific API URLs
            if config.isDevelopment {
                XCTAssertTrue(
                    config.apiBaseURL.contains("dev") ||
                        config.apiBaseURL.contains("development"),
                    "DEV should use dev API endpoint"
                )
            } else if config.isUAT {
                XCTAssertTrue(
                    config.apiBaseURL.contains("uat") ||
                        config.apiBaseURL.contains("staging"),
                    "UAT should use uat/staging API endpoint"
                )
            }
        }
    }

    func testDebugFeaturesInNonProduction() {
        let config = AppConfig.default

        if config.isProduction {
            // Production should have debug features disabled
            XCTAssertFalse(config.enableDebugMenu, "Production should disable debug menu")
        } else {
            // Dev/UAT can have debug features enabled
            print("Debug Menu enabled: \(config.enableDebugMenu)")
            print("Logging enabled: \(config.enableLogging)")
        }
    }
}
