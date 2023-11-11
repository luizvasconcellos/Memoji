//
//  SceneDelegate.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 05/11/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        coordinator = MainCoordinator(window: window!)
        coordinator?.start()
    }
}

