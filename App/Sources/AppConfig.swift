import Foundation

struct AppConfig {
    // MARK: - Properties
    let apiBaseURL: String
    let environment: String
    let appName: String
    let bundleIdentifier: String
    let enableLogging: Bool
    let enableDebugMenu: Bool
    let enableAnalytics: Bool
    let apiTimeout: TimeInterval

    // MARK: - Computed Properties
    var isDevelopment: Bool { environment == "dev" }
    var isUAT: Bool { environment == "uat" }
    var isProduction: Bool { environment == "prod" }
}

// MARK: - Convenience Extensions
extension AppConfig {
    init(
        apiBaseURL: String? = nil,
        environment: String? = nil,
        appName: String? = nil,
        bundleIdentifier: String? = nil,
        enableLogging: Bool? = nil,
        enableDebugMenu: Bool? = nil,
        enableAnalytics: Bool? = nil,
        apiTimeout: TimeInterval? = nil,
        bundle: Bundle = .main
    ) {
        self.apiBaseURL = apiBaseURL ?? bundle.infoDictionary?["API_BASE_URL"] as? String ?? ""
        // Convert environment to lowercase for consistency
        let rawEnvironment = environment ?? bundle.infoDictionary?["ENVIRONMENT"] as? String ?? "dev"
        self.environment = rawEnvironment.lowercased()
        self.appName = appName ?? bundle.infoDictionary?["CFBundleDisplayName"] as? String ?? "Sayar"
        self.bundleIdentifier = bundleIdentifier ?? bundle.bundleIdentifier ?? "com.mkg.sayar.dev"
        self.enableLogging = enableLogging ?? (bundle.infoDictionary?["ENABLE_LOGGING"] as? String == "YES")
        self.enableDebugMenu = enableDebugMenu ?? (bundle.infoDictionary?["ENABLE_DEBUG_MENU"] as? String == "YES")
        self.enableAnalytics = enableAnalytics ?? (bundle.infoDictionary?["ENABLE_ANALYTICS"] as? String == "YES")
        self.apiTimeout = apiTimeout ?? Double(bundle.infoDictionary?["API_TIMEOUT"] as? String ?? "30") ?? 30
    }

    func printCurrentConfig() {
        print("🏗️ App Configuration")
        print("📱 App Name: \(appName)")
        print("🌍 Environment: \(environment)")
        print("🌐 API Base URL: \(apiBaseURL)")
        print("📦 Bundle ID: \(bundleIdentifier)")
        print("🔧 Debug Menu: \(enableDebugMenu ? "✅" : "❌")")
        print("📝 Logging: \(enableLogging ? "✅" : "❌")")
        print("📊 Analytics: \(enableAnalytics ? "✅" : "❌")")
        print("⏱️ API Timeout: \(apiTimeout)s")
    }

    static let `default` = AppConfig()
}
