//
//  EmojiCollectionViewCell.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private lazy var emojiImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Properties
    var emojiUrl: String? {
        didSet {
            if let url = URL(string: emojiUrl ?? "") {
                emojiImage.download(from: url)
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
        
        contentView.addSubview(emojiImage)
        
        NSLayoutConstraint.activate([
            emojiImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            emojiImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            emojiImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            emojiImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
}
