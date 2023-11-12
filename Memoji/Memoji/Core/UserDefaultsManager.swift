//
//  UserDefaultsManager.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import Foundation

private struct UserDefaultsKeys {
    
    static let emojis = "Emojis"
}

final class UserDefaultsManager {
    
    // MARK: - Properties
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    // MARK: - Public Functions
    func getEmojisList() -> Emojis {
        
        do {
            let emojisList  = try defaults.getObject(forKey: UserDefaultsKeys.emojis, castTo: Emojis.self)
            return Dictionary(uniqueKeysWithValues: emojisList.sorted(by: { $0.key < $1.key}))
        } catch {
            print(error.localizedDescription)
        }
        return [:]
    }
    
    @discardableResult
    func addToList(emojis: Emojis) -> Bool {
        
        do {
            try defaults.setObject(emojis, forKey: UserDefaultsKeys.emojis)
            return true
        } catch {
            print (error.localizedDescription)
        }
        return false
    }
    
    func getRandomEmojiUrl() -> String {
        let emojisList = getEmojisList()
        return emojisList.values.randomElement() ?? ""
    }
}
