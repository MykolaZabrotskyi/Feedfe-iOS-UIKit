//
//  SceneDelegate.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 04.03.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        
        let networkService = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)
        
        window.rootViewController = FeedAssembly.build(with: networkService)
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

