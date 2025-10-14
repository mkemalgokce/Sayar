// Copyright © 2025 Mustafa Kemal Gökçe. 
// All rights reserved.

import FirebaseAnalytics
import FirebaseCore
import FirebaseCrashlytics
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()

        // Configure analytics based on environment
        let config = AppConfig.default
        Analytics.setAnalyticsCollectionEnabled(config.enableAnalytics)

        // Configure Crashlytics
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)

        // Set custom keys for crash reports
        Crashlytics.crashlytics().setCustomValue(config.environment, forKey: "environment")
        Crashlytics.crashlytics().setCustomValue(config.bundleIdentifier, forKey: "bundle_id")
        Crashlytics.crashlytics().setCustomValue(config.apiBaseURL, forKey: "api_url")

        // Log environment info to Analytics
        Analytics.setUserProperty(config.environment, forName: "environment")
        Analytics.setUserProperty(config.bundleIdentifier, forName: "bundle_id")

        // Log app launch with environment context
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: [
            "environment": config.environment,
            "build_type": config.isDevelopment ? "debug" : "release"
        ])

        // Print Firebase App info
        if let firebaseApp = FirebaseApp.app() {
            print("🔥 Firebase initialized")
            print("   Project ID: \(firebaseApp.options.projectID ?? "unknown")")
            print("   Google App ID: \(firebaseApp.options.googleAppID)")
            print("   Bundle ID: \(firebaseApp.options.bundleID)")
        }

        print("💥 Crashlytics initialized")
        print("   Collection enabled: \(Crashlytics.crashlytics().isCrashlyticsCollectionEnabled())")

        config.printCurrentConfig()

        // MARK: - Test Crash (Remove in production!)
        // Uncomment to test Crashlytics:
//         testCrash()

        return true
    }

    // MARK: - Crashlytics Test Function
    func testCrash() {
        // Log before crash for debugging
        Crashlytics.crashlytics().log("Testing crash reporting")
        Crashlytics.crashlytics().setCustomValue("test_crash", forKey: "crash_type")

        // Trigger a crash
        fatalError("Test crash for Crashlytics")
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
