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
    
    private var timer = Timer()
    private var remainingTime = 3600
    
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
        startGameButton.isEnabled = false
        
        timerLabel.text = "1:00:00"
        
        var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            endBackgroundTask()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let strongSelf = self else { return }
            
            let date = Date()
            let calendar = Calendar.current
            
            strongSelf.remainingTime -= 1
            
            if strongSelf.remainingTime == 0 {
                strongSelf.startGameButton.setTitle("Start game", for: .normal)
            } else {
                let hours = strongSelf.remainingTime / 3600
                let minutes = (strongSelf.remainingTime % 3600) / 60
                let seconds = strongSelf.remainingTime % 60
                strongSelf.timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                strongSelf.startGameButton.setTitle(strongSelf.timerLabel.text, for: .normal)
            }
            
            if strongSelf.remainingTime == 0 {
                timer.invalidate()
                strongSelf.startGameButton.isEnabled = true
                strongSelf.remainingTime = 3600
                endBackgroundTask()
            }
        }
                
        let wordle = Wordle(word: "state", time: 60)
        let vc = GameViewController(with: wordle, user: self.user)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
        func endBackgroundTask() {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskIdentifier.invalid
        }

    }
}

extension MainViewController: GameViewControllerDelegate {
    func didFinishGame(user: User) {
        self.user = user
    }
}
