//
//  EmojiListViewModel.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 11/11/23.
//

import Foundation
import RxSwift
import RxCocoa

final class EmojiListViewModel {
    // MARK: - Properties
    private var api: APIServiceDelegate
    private var emojis: Emojis = [:]
    
    // MARK: - init
    init(api: APIServiceDelegate) {
        self.api = api
    }
    
    // MARK: - Input & Output
    struct Input {
        let loadScreenObservable: Observable<Void>
        let refreshScreenObservable: Observable<Void>
    }
    
    struct Output {
        let emojisObservable: Driver<Emojis>
        let refreshScreenObservable: Driver<Emojis>
    }
    
    // MARK: - Connect
    func connect(input: Input) -> Output {
        let emojisObservable = input.loadScreenObservable
            .flatMap {[weak self] _ -> Observable<Emojis> in
                guard let self = self else { return Observable<Emojis>.empty() }
                
                self.emojis = UserDefaultsManager.shared.getEmojisList()
                if self.emojis.count > 0 {
                    return Observable<Emojis>.just(self.emojis)
                }
                
                return self.api.fetchEmojis()
                    .do(onSuccess: { emojis in
                        self.emojis = emojis
                        UserDefaultsManager.shared.addToList(emojis: emojis)
                    }).map { _ in
                        self.emojis
                    }.asObservable()
            }.asDriver(onErrorJustReturn: [:])
        
        let refreshScreenObservable = input.refreshScreenObservable
            .flatMap { [weak self] _ -> Observable<Emojis> in
                guard let self = self else { return Observable<Emojis>.empty() }
                return Observable<Emojis>.just(self.emojis)
            }.asDriver(onErrorJustReturn: [:])
        
        return Output(emojisObservable: emojisObservable,
                      refreshScreenObservable: refreshScreenObservable)
    }
}
