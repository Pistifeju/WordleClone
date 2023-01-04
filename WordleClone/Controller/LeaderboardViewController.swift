//
//  LeaderboardViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .yellow
        
        navigationItem.title = "Leaderboard"
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Selectors
}
