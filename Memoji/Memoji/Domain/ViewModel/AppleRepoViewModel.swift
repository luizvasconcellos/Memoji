//
//  AppleRepoViewModel.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 09/11/23.
//

import Foundation
import RxSwift
import RxCocoa

final class AppleRepoViewModel {
    
    // MARK: - Properties
    private var api: APIServiceDelegate
    private let itemsPerPage = 10
    private var nextPage = 1
    private var isLastPage = false
    private var isFetchingRepositories = false
    var repositories = [Repository]()
    
    // MARK: - init
    init(api: APIServiceDelegate) {
        self.api = api
    }
    
    // MARK: - Input & Output
    struct Input {
        let loadScreenObservable: Observable<Void>
        let loadMoreDataObservable: Observable<Void>
    }
    
    struct Output {
        let repositoriesObservable: Driver<[Repository]>
        let loadMoreObservable: Driver<[Repository]>
    }
    
    func connect(input: Input) -> Output {
        
        let repositoriesDriver = input.loadScreenObservable
            .do(onNext: { [weak self] _ in
                self?.isFetchingRepositories = true
            })
            .flatMap { [weak self] repositories -> Observable<[Repository]> in
                guard let self = self else { return Observable<[Repository]>.empty() }
                return self.api.fetchRepos(from: "apple", itemsPerPage: self.itemsPerPage, page: self.nextPage)
                        .do(onSuccess: { repositories in
                            self.addRepositoryToList(repositories)
                        })
                        .map { _ in
                            return self.repositories
                        }
                        .asObservable()
            }.asDriver(onErrorJustReturn: [])
        
        let loadMoreDriver = input.loadMoreDataObservable
            .skip(1)
            .do(onNext: { [weak self] _ in
                self?.isFetchingRepositories = true
            })
            .flatMapLatest { [weak self] _ -> Observable<[Repository]> in
                guard let self = self,
                      !self.isLastPage else { return Observable<[Repository]>.empty() }

                return self.api.fetchRepos(from: "apple", itemsPerPage: itemsPerPage, page: nextPage)
                    .do(onSuccess: { repositories in
                        self.addRepositoryToList(repositories)
                    })
                    .map {_ in
                        return self.repositories
                    }
                    .asObservable()
            }.asDriver(onErrorJustReturn: [])
        
        return Output(repositoriesObservable: repositoriesDriver,
                      loadMoreObservable: loadMoreDriver)
    }
    
    // MARK: - Private Functions
    private func addRepositoryToList(_ repos: [Repository]) {
        repositories.append(contentsOf: repos)
        nextPage += 1
        isLastPage = repositories.count < itemsPerPage
        isFetchingRepositories = false
    }
}

