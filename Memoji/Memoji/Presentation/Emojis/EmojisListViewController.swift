//
//  EmojisListViewController.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import UIKit

class EmojisListViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
    }

}
