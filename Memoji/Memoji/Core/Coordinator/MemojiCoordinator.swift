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
        
        if let vc = container.container.resolve(HomeViewController.self) {
            vc.homeCoordinatorDelegate = self
            navigationController.pushViewController(vc, animated: true)
        }
    }

    // MARK: - private Functions
    private func presentEmojisList() {
        if let vc = container.container.resolve(EmojisListCollectionViewController.self) {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    private func presentAppleRepositoriesScreen() {
        if let vc = container.container.resolve(AppleRepositoriesTableViewController.self) {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    private func presentAvatarListScreen() {
        if let vc = container.container.resolve(AvatarListViewController.self) {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension MemojiCoordinator: HomeCoordinatorDelegate {
    func homeViewControllerDidTapEmojies(_ viewController: HomeViewController) {
        presentEmojisList()
    }
    
    func homeViewControllerDidTapAvatars(_ viewController: HomeViewController) {
        presentAvatarListScreen()
    }
    
    func homeViewControllerDidTapAppleRepositories(_ viewController: HomeViewController) {
        presentAppleRepositoriesScreen()
    }
}
