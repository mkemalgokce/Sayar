// Copyright © 2025 Mustafa Kemal Gökçe. 
// All rights reserved.

import ProjectDescription

extension InfoPlist {
    /// Standard app Info.plist with environment configurations
    public static let appInfoPlist: InfoPlist = .extendingDefault(with: [
        "CFBundleDisplayName": "$(PRODUCT_DISPLAY_NAME)",
        "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ]
                ]
            ]
        ],
        // Environment Configuration
        "ENVIRONMENT": "$(ENVIRONMENT)",
        "API_BASE_URL": "$(API_BASE_URL)",
        "ENABLE_LOGGING": "$(ENABLE_LOGGING)",
        "ENABLE_DEBUG_MENU": "$(ENABLE_DEBUG_MENU)",
        "ENABLE_ANALYTICS": "$(ENABLE_ANALYTICS)",
        "API_TIMEOUT": "$(API_TIMEOUT)"
    ])
}
