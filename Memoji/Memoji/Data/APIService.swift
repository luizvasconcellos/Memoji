//
//  APIService.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 05/11/23.
//

import Foundation
import RxSwift

private struct Endpoint {
    
    static let emojis = "/emojis"
    static let users = "/users"
    static let repos = "/repos"
}

private struct Parameters {
    static let itemsPerPage = "per_page="
    static let page = "page="
}

protocol APIServiceDelegate {
    func fetchEmojis() -> Single<Emojis>
    func fetchRepos(from users: String, itemsPerPage: Int, page: Int) -> Single<[Repository]>
    func fetchUser(from user: String) -> Single<User?>
}

final class APIService {
    
    private var network: NetworkDelegate
    private var baseURL = "https://api.github.com"
    
    init(network: NetworkDelegate) {
        
        self.network = network
    }
}

extension APIService: APIServiceDelegate {
    
    func fetchEmojis() -> Single<Emojis> {
        Single.create { [weak self] observer in
            
            if let url = URL(string: "\(self?.baseURL ?? "")\(Endpoint.emojis)") {
                let request = NetworkRequest(method: .get, url: url)
                self?.network.baseRequest(request: request, type: Emojis.self, completion: { emojis, error in
                    guard let emojis = emojis else {
                        observer(.success([:]))
//                        observer(.error(BookServiceError.someError))
                        return
                    }
                    observer(.success(emojis))
                })
            }
            
            return Disposables.create()
        }
    }
    
    func fetchRepos(from user: String, itemsPerPage: Int, page: Int) -> Single<[Repository]> {
        Single.create { [weak self] observer in
            
            if let url = URL(string: "\(self?.baseURL ?? "")\(Endpoint.users)/\(user)\(Endpoint.repos)?\(Parameters.itemsPerPage)\(itemsPerPage)&\(Parameters.page)\(page)") {
                let request = NetworkRequest(method: .get, url: url)
                self?.network.baseRequest(request: request, type: [Repository].self, completion: { repositories, error in
                    guard let repositories = repositories else {
                        observer(.success([]))
                        return
                    }
                    observer(.success(repositories))
                })
            }
            
            return Disposables.create()
        }
    }
    
    func fetchUser(from user: String) -> Single<User?> {
        Single.create { [weak self] observer in
            
            if let url = URL(string: "\(self?.baseURL ?? "")\(Endpoint.users)/\(user)") {
                let request = NetworkRequest(method: .get, url: url)
                self?.network.baseRequest(request: request, type: User.self, completion: { user, error in
                    guard let user = user else {
                        observer(.success(nil))
                        return
                    }
                    observer(.success(user))
                })
            }
            
            return Disposables.create()
        }
    }
}
