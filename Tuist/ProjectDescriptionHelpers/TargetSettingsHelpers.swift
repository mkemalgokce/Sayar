import ProjectDescription

// MARK: - Signing Configuration

public enum Signing {
    /// Development team ID
    private static let teamID = "Q9ARVAPAG3"

    /// Manual signing base settings
    public static let manualBase: SettingsDictionary = [
        "CODE_SIGN_STYLE": "Manual",
        "DEVELOPMENT_TEAM": .string(teamID)
    ]

    public static let automaticBase: SettingsDictionary = [
        "CODE_SIGN_STYLE": "Automatic",
        "CODE_SIGN_IDENTITY": "Apple Development",
        "DEVELOPMENT_TEAM": .string(teamID),
        "PROVISIONING_PROFILE_SPECIFIER": ""
    ]

    /// Returns signing settings for a specific configuration
    private static func settings(for config: BuildConfigName) -> SettingsDictionary {
        switch config {
        case .dev:
            [
                "CODE_SIGN_IDENTITY": "Apple Development",
                "PROVISIONING_PROFILE_SPECIFIER": "Sayar App Dev Profile"
            ]
        case .uat:
            [
                "CODE_SIGN_IDENTITY": "Apple Distribution",
                "PROVISIONING_PROFILE_SPECIFIER": "Sayar App UAT Adhoc Profile"
            ]
        case .prod:
            [
                "CODE_SIGN_IDENTITY": "Apple Distribution",
                "PROVISIONING_PROFILE_SPECIFIER": "Sayar App Prod Profile"
            ]
        }
    }

    /// App configurations with signing and xcconfig
    public static func appConfigurations() -> [Configuration] {
        BuildConfigName.allCases.map { config in
            if config.isDebug {
                .debug(
                    name: config.configurationName,
                    settings: settings(for: config),
                    xcconfig: config.xcconfigPath
                )
            } else {
                .release(
                    name: config.configurationName,
                    settings: settings(for: config),
                    xcconfig: config.xcconfigPath
                )
            }
        }
    }
}

// MARK: - Test Target Settings

public enum TestTargetSettings {
    /// Automatic signing base settings for test targets
    public static let base: SettingsDictionary = [
        "CODE_SIGN_STYLE": "Automatic",
        "CODE_SIGN_IDENTITY": "Apple Development",
        "DEVELOPMENT_TEAM": "Q9ARVAPAG3",
        "PROVISIONING_PROFILE_SPECIFIER": ""
    ]

    /// Test configurations (works for both module and app tests)
    public static func configurations() -> [Configuration] {
        BuildConfigName.allCases.map { .moduleConfig($0) }
    }
}
