//
//  AvatarListViewModel.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 12/11/23.
//

import Foundation
import RxSwift
import RxCocoa

final class AvatarListViewModel {
    
    // MARK: - Properties
    private var users: [User] = []
    
    // MARK: - Input & Output
    struct Input {
        let loadScreenObservable: Observable<Void>
    }
    
    struct Output {
        let usersObservable: Driver<[User]>
    }
    
    // MARK: - Connect
    func connect(input: Input) -> Output {
        let loadScreenObservable = input.loadScreenObservable
            .flatMap {[weak self] _ -> Observable<[User]> in
                guard let self = self else { return Observable<[User]>.empty() }
                return Observable<[User]>.just(UserDefaultsManager.shared.getUsersList())
            }.asDriver(onErrorJustReturn: [])
        
        return Output(usersObservable: loadScreenObservable)
    }
}
