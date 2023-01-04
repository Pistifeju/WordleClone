//
//  SettingsHeaderView.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 04..
//

import UIKit

class SettingsHeaderView: UIView {
    
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

