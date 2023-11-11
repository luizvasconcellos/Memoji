//
//  EmojisListCollectionViewController.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import UIKit
import RxSwift
import RxCocoa

final class EmojisListCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    var emojisViewModel: HomeViewModel?
    private let reuseIdentifier = "Cell"
    private var emojis: Emojis = Emojis() {
        didSet {
            collectionView.reloadData()
        }
    }
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Emojis"
        registerCell()
//        setupBindings()
    }
    
    private func registerCell() {
        self.collectionView!.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
//    private func setupBindings() {
//        
//        let input = EmojisViewModel.Input(loadScreenObservable: rx.viewWillAppear
//            .asObservable()
//            .map { _ in
//                Void()
//            }
//        )
//        
//        let connect = emojisViewModel?.connect(input: input)
//        
//        connect?.emojisObservable
//            .drive(onNext: { [weak self] emojis in
//                self?.emojis = emojis
//            }).disposed(by: disposeBag)
//    }
    
    
    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
    
        cell.emojiUrl = Array(emojis.values)[indexPath.row]
    
        return cell
    }

}
