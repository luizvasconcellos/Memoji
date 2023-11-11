//
//  Repository.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 09/11/23.
//

import Foundation

struct Repository: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}
