//
//  HomeViewController.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 06/11/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeCoordinatorDelegate: AnyObject {
    func homeViewControllerDidTapEmojies(_ viewController: HomeViewController)
    func homeViewControllerDidTapAvatars(_ viewController: HomeViewController)
    func homeViewControllerDidTapAppleRepositories(_ viewController: HomeViewController)
}

final class HomeViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        
        return view
    }()
    
    private lazy var randomEmojiButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var emojiesButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Emojis list", for: .normal)
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var avatarsButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Avatars list", for: .normal)
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var appleReposButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Apple repos", for: .normal)
        view.heightAnchor.constraint(equalToConstant: 45).isActive = true
        view.backgroundColor = .systemBlue
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var randomImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        return view
    }()
    
    // MARK: - Properties
    weak var homeCoordinatorDelegate: HomeCoordinatorDelegate?
    var homeViewModel: HomeViewModel?
    private var randomButtonType: HomeViewModel.GetEmojiButtonType?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Memoji"
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(randomEmojiButton)
        stackView.addArrangedSubview(emojiesButton)
        stackView.addArrangedSubview(avatarsButton)
        stackView.addArrangedSubview(appleReposButton)
        
        view.addSubview(randomImage)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            randomImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16),
            randomImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        randomImage.isHidden = true
        emojiesButton.addTarget(self, action: #selector(emojiesListDidTapped), for: .touchUpInside)
        appleReposButton.addTarget(self, action: #selector(appleRepositoriesDidTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        let input = HomeViewModel.Input(loadScreenObservable: rx.viewDidAppear
            .asObservable()
            .map { _ in
                Void()
            },
                                          getEmojiButtonTappedObservable: randomEmojiButton.rx.tap.asObservable())
        
        let output = homeViewModel?.connect(input: input)
        
        output?.getOrRandonEmojiButtonTypeObservable
            .drive(onNext: { [weak self] buttonType in
                self?.randomEmojiButton.setTitle(buttonType.getButtonName(), for: .normal)
                self?.randomButtonType = buttonType
            }).disposed(by: disposeBag)
        
        output?.emojisObservable
            .drive(onNext: { [weak self] imgURL in
                if let url = URL(string: imgURL) {
                    self?.randomImage.isHidden = false
                    self?.randomImage.download(from: url)
                } else {
                    self?.randomImage.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
    
    @objc private func emojiesListDidTapped() {
        homeCoordinatorDelegate?.homeViewControllerDidTapEmojies(self)
    }
    
    @objc private func appleRepositoriesDidTapped() {
        homeCoordinatorDelegate?.homeViewControllerDidTapAppleRepositories(self)
    }
}
