//
//  MainViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let startGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Game", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameButton.addTarget(self, action: #selector(didTapStartGame), for: .touchUpInside)
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBlue
        
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
        let vc = GameViewController(with: wordle)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
