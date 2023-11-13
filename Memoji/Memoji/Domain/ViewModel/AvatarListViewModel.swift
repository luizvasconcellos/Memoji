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
    var users: [User] = []
    
    // MARK: - Input & Output
    struct Input {
        let loadScreenObservable: Observable<Void>
        let deleteUserObservable: Observable<User>
    }
    
    struct Output {
        let usersObservable: Driver<[User]>
        let deleteUserObservable: Driver<(Bool, String)>
    }
    
    // MARK: - Connect
    func connect(input: Input) -> Output {
        let loadScreenObservable = input.loadScreenObservable
            .flatMap { _ -> Observable<[User]> in
                return Observable<[User]>.just(UserDefaultsManager.shared.getUsersList())
            }.asDriver(onErrorJustReturn: [])
        
        let deleteUserObservable = input.deleteUserObservable
            .flatMap { [weak self] user -> Observable<(Bool, String)> in
                guard let self = self else { return Observable<(Bool, String)>.just((false, "sorry we was not able to delete the avatar.")) }
                let isDeleted = UserDefaultsManager.shared.removeUserFromList(user.id)
                if isDeleted {
                    self.users = UserDefaultsManager.shared.getUsersList()
                    return Observable<(Bool, String)>.just((true, ""))
                }
                return Observable<(Bool, String)>.just((false, "sorry we was not able to delete the avatar."))
            }.asDriver(onErrorJustReturn: (false, "sorry we was not able to delete the avatar."))
        
        return Output(usersObservable: loadScreenObservable,
                      deleteUserObservable: deleteUserObservable)
    }
}
