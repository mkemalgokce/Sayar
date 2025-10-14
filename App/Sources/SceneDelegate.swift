// Copyright © 2025 Mustafa Kemal Gökçe. 
// All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appconfig: AppConfig = .default

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        setupWindow()
        appconfig.printCurrentConfig()
    }

    // MARK: - Private Methods
    private func setupWindow() {
        let vc = ViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
