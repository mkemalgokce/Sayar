import ProjectDescription

// MARK: - Build Configuration Names

public enum BuildConfigName: String, CaseIterable {
    case dev = "Dev"
    case uat = "UAT"
    case prod = "Prod"

    /// Returns the ConfigurationName for Tuist
    public var configurationName: ConfigurationName {
        .configuration(rawValue)
    }

    /// Returns the xcconfig file path for this configuration
    public var xcconfigPath: Path {
        .relativeToRoot("Config/\(fileName).xcconfig")
    }

    /// Returns whether this is a debug configuration
    public var isDebug: Bool {
        self == .dev
    }

    private var fileName: String {
        switch self {
        case .dev: "Dev"
        case .uat: "UAT"
        case .prod: "Prod"
        }
    }
}

// MARK: - Configuration Extensions

extension Configuration {
    /// Creates a configuration for the given build config name with xcconfig
    public static func from(_ config: BuildConfigName) -> Configuration {
        if config.isDebug {
            .debug(name: config.configurationName, xcconfig: config.xcconfigPath)
        } else {
            .release(name: config.configurationName, xcconfig: config.xcconfigPath)
        }
    }

    /// Creates a configuration for the given build config name without xcconfig (for modules)
    public static func moduleConfig(_ config: BuildConfigName) -> Configuration {
        if config.isDebug {
            .debug(name: config.configurationName)
        } else {
            .release(name: config.configurationName)
        }
    }
}

// MARK: - Build Configurations

public enum BuildConfigurations {
    /// Environment-specific configurations for the main App target
    public static func standard() -> [Configuration] {
        BuildConfigName.allCases.map { .from($0) }
    }

    /// Environment-agnostic configurations for modules (Shared & Feature)
    /// Modules use same configuration names as App but without environment-specific xcconfigs
    /// This ensures Xcode can properly link modules when building the app
    public static func module() -> [Configuration] {
        BuildConfigName.allCases.map { .moduleConfig($0) }
    }
}
