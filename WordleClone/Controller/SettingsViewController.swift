//
//  SettingsViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .green
        
        navigationItem.title = "Settings"
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Selectors
}
