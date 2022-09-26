//
//  SceneDelegate.swift
//  Spotify
//
//  Created by Yan Pepik
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        let navigationController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navigationController
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}
