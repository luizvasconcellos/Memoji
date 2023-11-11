//
//  Coordinator.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 05/11/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}
