import ProjectDescription

// MARK: - Constants

private enum ProjectConstants {
    static let bundleIdPrefix = "com.mkg.sayar"
    static let minimumIOSVersion = "16.0"
}

// MARK: - Target Extensions

extension Target {
    /// Creates a module target (shared or feature)
    public static func module(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(ProjectConstants.bundleIdPrefix).\(name.lowercased())",
            deploymentTargets: .iOS(ProjectConstants.minimumIOSVersion),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies,
            settings: .settings(base: Signing.automaticBase)
        )
    }

    /// Creates a test target for modules
    public static func moduleTests(for moduleName: String) -> Target {
        .target(
            name: "\(moduleName)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(ProjectConstants.bundleIdPrefix).\(moduleName.lowercased()).tests",
            deploymentTargets: .iOS(ProjectConstants.minimumIOSVersion),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: moduleName)],
            settings: .settings(
                base: TestTargetSettings.base,
                configurations: TestTargetSettings.configurations()
            )
        )
    }

    /// Creates an app target
    public static func app(
        name: String,
        bundleId: String = "$(PRODUCT_BUNDLE_IDENTIFIER)",
        dependencies: [TargetDependency] = []
    ) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS(ProjectConstants.minimumIOSVersion),
            infoPlist: .appInfoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [.firebaseConfig, .crashlyticsUpload],
            dependencies: dependencies,
            settings: .settings(
                base: Signing.manualBase,
                configurations: Signing.appConfigurations()
            )
        )
    }

    /// Creates unit tests target for app
    public static func appUnitTests(for appName: String) -> Target {
        .target(
            name: "\(appName)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(ProjectConstants.bundleIdPrefix).app.tests",
            deploymentTargets: .iOS(ProjectConstants.minimumIOSVersion),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: appName)],
            settings: .settings(
                base: TestTargetSettings.base,
                configurations: TestTargetSettings.configurations()
            )
        )
    }

    /// Creates UI tests target for app
    public static func appUITests(for appName: String) -> Target {
        .target(
            name: "\(appName)UITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "\(ProjectConstants.bundleIdPrefix).app.uitests",
            deploymentTargets: .iOS(ProjectConstants.minimumIOSVersion),
            infoPlist: .default,
            sources: ["UITests/**"],
            dependencies: [.target(name: appName)],
            settings: .settings(
                base: TestTargetSettings.base,
                configurations: TestTargetSettings.configurations()
            )
        )
    }
}

// MARK: - Scheme Extensions

extension Scheme {
    /// Creates a scheme for modules (Shared/Feature)
    public static func module(name: String, coverageTargets: [TargetReference] = []) -> Scheme {
        let effectiveCoverageTargets = coverageTargets.isEmpty ? [.target(name)] : coverageTargets
        return .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: [.target(name)]),
            testAction: .targets(
                [.testableTarget(target: .target("\(name)Tests"))],
                configuration: BuildConfigName.dev.configurationName,
                options: .options(coverage: true, codeCoverageTargets: effectiveCoverageTargets)
            ),
            runAction: .runAction(configuration: BuildConfigName.dev.configurationName)
        )
    }

    /// Creates app schemes for all environments
    public static func app(name: String, coverageTargets: [TargetReference]) -> [Scheme] {
        BuildConfigName.allCases.map { config in
            createAppScheme(name: name, config: config, coverageTargets: coverageTargets)
        }
    }

    /// Creates a single app scheme for a specific environment
    private static func createAppScheme(
        name: String,
        config: BuildConfigName,
        coverageTargets: [TargetReference]
    ) -> Scheme {
        let testTargets: [TestableTarget] = [
            .testableTarget(target: .target("\(name)Tests")),
            .testableTarget(target: .target("\(name)UITests"))
        ]

        let firebaseLaunchArgs: [LaunchArgument] = [
            .launchArgument(name: "-FIRDebugEnabled", isEnabled: true),
            .launchArgument(name: "-FIRAnalyticsDebugEnabled", isEnabled: true)
        ]

        let runAction: RunAction = if config != .prod {
            .runAction(
                configuration: config.configurationName,
                arguments: .arguments(launchArguments: firebaseLaunchArgs)
            )
        } else {
            .runAction(configuration: config.configurationName)
        }

        return .scheme(
            name: "\(name) \(config.rawValue)",
            shared: true,
            buildAction: .buildAction(targets: [.target(name)]),
            testAction: .targets(
                testTargets,
                configuration: config.configurationName,
                options: .options(coverage: true, codeCoverageTargets: coverageTargets)
            ),
            runAction: runAction,
            archiveAction: .archiveAction(configuration: config.configurationName)
        )
    }
}

// MARK: - Project Extensions

extension Project {
    /// Creates a shared module project
    public static func shared(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        .module(name: name, dependencies: dependencies)
    }

    public static func feature(
        name: String,
        dependencies: [TargetDependency] = [.shared(.common)]
    ) -> Project {
        .module(name: name, dependencies: dependencies)
    }

    private static func module(
        name: String,
        dependencies: [TargetDependency]
    ) -> Project {
        Project(
            name: name,
            options: .options(automaticSchemesOptions: .disabled),
            settings: .settings(configurations: BuildConfigurations.module()),
            targets: [
                .module(name: name, dependencies: dependencies),
                .moduleTests(for: name)
            ],
            schemes: [.module(name: name)]
        )
    }

    public static func app(
        name: String,
        bundleId: String = "$(PRODUCT_BUNDLE_IDENTIFIER)",
        dependencies: [TargetDependency] = []
    ) -> Project {
        let coverageTargets: [TargetReference] = [.target(name)]

        return Project(
            name: name,
            options: .options(
                automaticSchemesOptions: .disabled,
                disableBundleAccessors: true,
                disableSynthesizedResourceAccessors: false
            ),
            settings: .settings(configurations: BuildConfigurations.standard()),
            targets: [
                .app(name: name, bundleId: bundleId, dependencies: dependencies),
                .appUnitTests(for: name),
                .appUITests(for: name)
            ],
            schemes: Scheme.app(name: name, coverageTargets: coverageTargets)
        )
    }
}

// MARK: - TargetScript Extensions
extension TargetScript {
    /// Script to copy Firebase config based on environment
    public static let firebaseConfig = BuildScripts.firebaseConfig
    /// Script to upload dSYMs to Crashlytics
    public static let crashlyticsUpload = BuildScripts.crashlyticsUpload
}
