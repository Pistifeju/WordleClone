//
//  MainViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User
    
    private let startGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Game", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameButton.addTarget(self, action: #selector(didTapStartGame), for: .touchUpInside)
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        navigationItem.title = "Home"
        
        view.addSubview(startGameButton)
        
        NSLayoutConstraint.activate([
            startGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startGameButton.heightAnchor.constraint(equalToConstant: 100),
            startGameButton.widthAnchor.constraint(equalTo: startGameButton.heightAnchor)
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapStartGame() {
        // TODO: - Generate wordle
        let wordle = Wordle(word: "state", time: 60)
        let vc = GameViewController(with: wordle, user: self.user)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - GameViewControllerDelegate

extension MainViewController: GameViewControllerDelegate {
    func didFinishGame(user: User) {
        self.user = user
    }
}
