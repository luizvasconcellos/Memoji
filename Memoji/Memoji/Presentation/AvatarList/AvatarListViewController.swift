//
//  AvatarListViewController.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 12/11/23.
//

import UIKit
import RxSwift
import RxCocoa

final class AvatarListViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    // MARK: - Properties
    var avatarViewModel: AvatarListViewModel?
    var refreshScreenObservable = PublishSubject<Void>()
    private let reuseIdentifier = "Cell"
    private var users: [User] = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Avatars"
        collectionView.dataSource = self
        collectionView.delegate = self
        setupUI()
        registerCell()
        setupBindings()
    }
}
// MARK: - Private Functions
extension AvatarListViewController {
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func registerCell() {
        collectionView.register(GenericImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func setupBindings() {
        
        let input = AvatarListViewModel.Input(loadScreenObservable: rx.viewWillAppear
            .asObservable()
            .map { _ in
                Void()
            })
        
        let connect = avatarViewModel?.connect(input: input)
        
        connect?.usersObservable
            .drive(onNext: { [weak self] users in
                if users.count > 0 {
                    self?.users = users
                } else {
                    self?.showAlert(withMessage: "Here you can see the users you searched, but until now you do not searched for someone on GitHub.")
                }
            }).disposed(by: disposeBag)
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "We do not have avatar to show, yet ;)", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func refreshEmojiList(_ sender: Any) {
        refreshScreenObservable.onNext(())
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension AvatarListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GenericImageCollectionViewCell
    
        cell.imageUrl = users[indexPath.row].avatarURL
    
        return cell
    }
}
