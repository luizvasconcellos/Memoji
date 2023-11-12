//
//  MemojiContainer.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import Foundation
import Swinject

final class MemojiContainer {
    
    let container = Container()
    
    init() {
        Container.loggingFunction = nil
        setup()
    }
    
    private func setup() {
        
        // MARK: - Core
        container.register(NetworkDelegate.self) { _ in Network() }
        
        // MARK: - API
        container.register(APIServiceDelegate.self) { resolver in
            let network = resolver.resolve(NetworkDelegate.self)!
            return APIService(network: network)
        }
        
        // MARK: - ViewModel
        container.register(HomeViewModel.self) { resolver in
            let api = resolver.resolve(APIServiceDelegate.self)
            return HomeViewModel(api: api!)
        }
        
        container.register(AppleRepoViewModel.self) { resolver in
            let api = resolver.resolve(APIServiceDelegate.self)
            return AppleRepoViewModel(api: api!)
        }
        
        container.register(EmojiListViewModel.self) { resolver in
            let api = resolver.resolve(APIServiceDelegate.self)
            return EmojiListViewModel(api: api!)
        }
        
        // MARK: - ViewController
        container.register(HomeViewController.self) { resolver in
            let controller = HomeViewController()
            controller.homeViewModel = resolver.resolve(HomeViewModel.self)
            return controller
        }
        
        container.register(EmojisListCollectionViewController.self) { resolver in
            let controller = EmojisListCollectionViewController()
            controller.emojisViewModel = resolver.resolve(EmojiListViewModel.self)
            return controller
        }
        
        container.register(AppleRepositoriesTableViewController.self) { resolver in
            let controller = AppleRepositoriesTableViewController()
            controller.appleRepoViewModel = resolver.resolve(AppleRepoViewModel.self)
            return controller
        }
    }
}
