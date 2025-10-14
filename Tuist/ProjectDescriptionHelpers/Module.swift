import ProjectDescription

// MARK: - Module Protocol

/// Protocol defining common behavior for all module types
public protocol Module: RawRepresentable, CaseIterable where RawValue == String {
    /// The base directory path for this module type
    static var basePath: String { get }
}

extension Module {
    /// The display name of the module
    public var name: String { rawValue }

    /// The file system path to the module
    public var path: Path { .relativeToRoot("\(Self.basePath)/\(rawValue)") }

    /// The target dependency reference for this module
    public var dependency: TargetDependency {
        .project(target: rawValue, path: path)
    }

    /// All dependencies for this module type
    public static var all: [TargetDependency] {
        allCases.map(\.dependency)
    }
}

// MARK: - Shared Modules

public enum SharedModule: String, CaseIterable, Module {
    case common = "Common"

    public static let basePath = "Shared"
}

// MARK: - Feature Modules

public enum FeatureModule: String, CaseIterable, Module {
    case onboarding = "Onboarding"

    public static let basePath = "Features"
}

// MARK: - TargetDependency Convenience

extension TargetDependency {
    /// Creates a dependency to a shared module
    public static func shared(_ module: SharedModule) -> TargetDependency {
        module.dependency
    }

    /// Creates a dependency to a feature module
    public static func feature(_ module: FeatureModule) -> TargetDependency {
        module.dependency
    }
}
