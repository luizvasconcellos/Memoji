//
//  EmojisListCollectionViewController.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import UIKit
import RxSwift
import RxCocoa

final class EmojisListCollectionViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    // MARK: - Properties
    var emojisViewModel: EmojiListViewModel?
    var refreshScreenObservable = PublishSubject<Void>()
    private let reuseIdentifier = "Cell"
    private var emojis: Emojis = Emojis() {
        didSet {
            collectionView.reloadData()
        }
    }
    private let disposeBag = DisposeBag()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Emojis"
        collectionView.dataSource = self
        collectionView.delegate = self
        setupUI()
        registerCell()
        setupBindings()
    }
}
    // MARK: - Private Functions
extension EmojisListCollectionViewController {
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        collectionView.addSubview(refreshControl)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        refreshControl.addTarget(self, action: #selector(refreshEmojiList(_:)), for: .valueChanged)
    }
    
    private func registerCell() {
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func setupBindings() {
        
        let input = EmojiListViewModel.Input(loadScreenObservable: rx.viewWillAppear
            .asObservable()
            .map { _ in
                Void()
            },
                                             refreshScreenObservable: refreshScreenObservable.asObservable()
        )
        
        let connect = emojisViewModel?.connect(input: input)
        
        connect?.emojisObservable
            .drive(onNext: { [weak self] emojis in
                self?.emojis = emojis
            }).disposed(by: disposeBag)
        
        connect?.refreshScreenObservable
            .drive(onNext: { [weak self] emojis in
                    self?.emojis = emojis
                    self?.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
    }
    
    @objc private func refreshEmojiList(_ sender: Any) {
        refreshScreenObservable.onNext(())
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate
extension EmojisListCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
    
        cell.emojiUrl = Array(emojis.values)[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyArray = Array(emojis.keys)
        print("keyArray COUNT:\(keyArray.count)")
        emojis.removeValue(forKey: keyArray[indexPath.row])
        collectionView.reloadData()
    }
}
