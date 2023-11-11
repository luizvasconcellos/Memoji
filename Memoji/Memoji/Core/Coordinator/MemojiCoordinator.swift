//
//  MemojiCoordinator.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 05/11/23.
//

import UIKit

final class MemojiCoordinator: Coordinator {

    // MARK: - Properties
    let container = MemojiContainer()
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var presentingViewController: UIViewController?

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        self.navigationController = UINavigationController()
    }

    // MARK: - Start
    func start() {
        
        let vc = HomeViewController()
        vc.homeCoordinatorDelegate = self
        vc.homeViewModel = container.container.resolve(HomeViewModel.self)
        navigationController.pushViewController(vc, animated: true)
    }

    // MARK: - private Functions
    private func presentEmojisList() {

        let vc = EmojisListCollectionViewController()

        navigationController.pushViewController(vc, animated: true)
    }
    
    private func presentAppleRepositoriesScreen() {
        if let vc = container.container.resolve(AppleRepositoriesTableViewController.self) {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension MemojiCoordinator: HomeCoordinatorDelegate {
    func homeViewControllerDidTapEmojies(_ viewController: HomeViewController) {
        presentEmojisList()
    }
    
    func homeViewControllerDidTapAvatars(_ viewController: HomeViewController) {
        
    }
    
    func homeViewControllerDidTapAppleRepositories(_ viewController: HomeViewController) {
        presentAppleRepositoriesScreen()
    }
}
