//
//  LeaderboardHeaderView.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 05..
//


import UIKit

class LeaderboardHeaderView: UIView {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .green
        
    }
    
    // MARK: - Selectors
    
}

