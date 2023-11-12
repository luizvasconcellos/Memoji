//
//  AppleRepositoriesTableViewController.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 09/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class AppleRepositoriesTableViewController: UITableViewController {

    // MARK: - Properties
    var appleRepoViewModel: AppleRepoViewModel?
    var loadMoreObservable = PublishSubject<Void>()
    private var appleRepositories: [Repository]? {
        didSet {
            tableView.reloadData()
        }
    }
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Apple Repositories"
        registerCell()
        setupBindings()
    }
    
    // MARK: - Private functions
    private func registerCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    private func setupBindings() {
        let input = AppleRepoViewModel.Input(loadScreenObservable: rx.viewDidAppear
            .asObservable()
            .map { _ in
                Void()
            },
                                             loadMoreDataObservable: loadMoreObservable
            .asObservable()
            .map { _ in
                Void()
            })
        
        let connect = appleRepoViewModel?.connect(input: input)
        
        connect?.repositoriesObservable
            .drive(onNext: { [weak self] repos in
                self?.appleRepositories = repos
            }).disposed(by: disposeBag)
        
        connect?.loadMoreObservable
            .drive(onNext: { [weak self] repos in
                self?.appleRepositories = repos
            }).disposed(by: disposeBag)
    }
    
    // MARK: - scrollView
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if (distanceFromBottom < height) {
            loadMoreObservable.onNext(Void())
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appleRepositories?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repo = appleRepositories?[indexPath.row],
              let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell") else { return UITableViewCell() }
        
        cell.textLabel?.text = repo.name
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}
