//
//  MainCoordinator.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 05/11/23.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    var rootViewController: UIViewController
    var childCoordinators = [Coordinator]()
    private let window: UIWindow
    private var navigationController: UINavigationController {
        return rootViewController as! UINavigationController
    }
    
    // MARK: - Init
    init(window: UIWindow) {
        
        self.window = window
        rootViewController = UINavigationController()
    }
    
    // MARK: - Public Functions
    func start() {
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let coordinator = MemojiCoordinator(navigationController: navigationController)
        coordinator.start()
        
        addChildCoordinator(coordinator)
    }
}
