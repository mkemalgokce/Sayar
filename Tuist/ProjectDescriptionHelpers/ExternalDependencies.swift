import ProjectDescription

// MARK: - External Dependencies

public enum ExternalDependency {
    // Firebase
    case firebaseAnalytics
    case firebaseCrashlytics
    case firebaseMessaging
    case firebaseRemoteConfig

    public var targetDependency: TargetDependency {
        switch self {
        case .firebaseAnalytics:
            .external(name: "FirebaseAnalytics")
        case .firebaseCrashlytics:
            .external(name: "FirebaseCrashlytics")
        case .firebaseMessaging:
            .external(name: "FirebaseMessaging")
        case .firebaseRemoteConfig:
            .external(name: "FirebaseRemoteConfig")
        }
    }
}

// MARK: - Convenience Extensions

extension TargetDependency {
    public static func external(_ dependency: ExternalDependency) -> TargetDependency {
        dependency.targetDependency
    }
}

// MARK: - Predefined Dependency Groups

public enum DependencyGroup {
    /// Core Firebase dependencies for analytics and crash reporting
    public static var firebaseCore: [TargetDependency] {
        [
            .external(.firebaseAnalytics),
            .external(.firebaseCrashlytics)
        ]
    }

    /// All Firebase dependencies
    public static var firebaseAll: [TargetDependency] {
        [
            .external(.firebaseAnalytics),
            .external(.firebaseCrashlytics),
            .external(.firebaseMessaging),
            .external(.firebaseRemoteConfig)
        ]
    }
}
