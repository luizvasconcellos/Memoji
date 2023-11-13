//
//  UserDefaultsManager.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import Foundation

private struct UserDefaultsKeys {
    
    static let emojis = "Emojis"
    static let users = "Users"
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
    
    @discardableResult
    func addUserToList(_ user: User) -> Bool {
        
        do {
            var users = getUsersList()
            users.append(user)
            try defaults.setObject(users, forKey: UserDefaultsKeys.users)
            return true
        } catch {
            print (error.localizedDescription)
        }
        return false
    }
    
    func getUsersList() -> [User] {
        
        do {
            return try defaults.getObject(forKey: UserDefaultsKeys.users, castTo: [User].self)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func getUser(withLogin login: String) -> User? {
        let users = getUsersList()
        return users.first(where: { $0.login == login })
    }
    
    func removeUserFromList(_ userId: Int) -> Bool {
        
        var bookmarksList = getUsersList()
        guard let index = bookmarksList.firstIndex( where: { $0.id == userId } ) else  { return false }
        bookmarksList.remove(at: index)
        do {
            try defaults.setObject(bookmarksList, forKey: UserDefaultsKeys.users)
            return true
        } catch {
            print (error.localizedDescription)
        }
        return false
    }
}
