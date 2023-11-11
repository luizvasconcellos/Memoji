//
//  HomeViewModel.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    public enum GetEmojiButtonType: CaseIterable {
        case getEmojis
        case randomEmoji
        
        func getButtonName() -> String {
            switch self {
            case .getEmojis:
                return "Get Emojis"
            case .randomEmoji:
                return "Random Emoji"
            }
        }
    }
    
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
        let getEmojiButtonTappedObservable: Observable<Void>
    }
    
    struct Output {
        let emojisObservable: Driver<String>
        let getOrRandonEmojiButtonTypeObservable: Driver<GetEmojiButtonType>
    }
    
    // MARK: - Connect
    func connect(input: Input) -> Output {
        let emojisObservable = input.getEmojiButtonTappedObservable
            .flatMap {[weak self] _ -> Observable<String> in
                guard let self = self else { return Observable<String>.empty() }
                
                if UserDefaultsManager.shared.getEmojisList().count > 0 {
                    return Observable<String>.just(UserDefaultsManager.shared.getRandomEmojiUrl())
                }
                
                return self.api.fetchEmojis()
                    .do(onSuccess: { emojis in
                        self.emojis = emojis
                        UserDefaultsManager.shared.addToList(emojis: emojis)
                    }).map { _ in
                        ""
                    }.asObservable()
            }
            .startWith("")
            .asDriver(onErrorJustReturn: "")
        
        let getOrRandonEmojiButtonTypeObservable = Observable.of(input.loadScreenObservable, input.getEmojiButtonTappedObservable)
            .flatMap {[weak self] _ -> Observable<GetEmojiButtonType> in
                guard let self = self else { return Observable<GetEmojiButtonType>.just(.getEmojis) }
               
                self.emojis = UserDefaultsManager.shared.getEmojisList()
                if self.emojis.count > 0 {
                    return Observable<GetEmojiButtonType>.just(.randomEmoji)
                }
                return Observable<GetEmojiButtonType>.just(.getEmojis)
                
            }
            .startWith(.getEmojis)
            .asDriver(onErrorJustReturn: GetEmojiButtonType.getEmojis)
        
        return Output(emojisObservable: emojisObservable,
                      getOrRandonEmojiButtonTypeObservable: getOrRandonEmojiButtonTypeObservable)
    }
}

// MARK: - Private Functions
extension HomeViewModel {
    
}
