//
//  User.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 12/11/23.
//

import Foundation

struct User: Codable {
    let login: String
    let id: Int
    let avatarURL: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case name
    }
}
