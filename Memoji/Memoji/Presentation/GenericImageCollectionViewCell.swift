//
//  GenericImageCollectionViewCell.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import UIKit

final class GenericImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private lazy var cellImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        return view
    }()
    
    // MARK: - Properties
    var imageUrl: String? {
        didSet {
            if let url = URL(string: imageUrl ?? "") {
                cellImage.download(from: url)
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        
        self.backgroundColor = .clear
        
        contentView.addSubview(cellImage)
        
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            cellImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            cellImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
}
