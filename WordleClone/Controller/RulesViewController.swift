//
//  RulesViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 29..
//

import Foundation
import UIKit

class RulesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How To Play"
        label.textColor = UIColor.label
        return label
    }()
    
    private var secondaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Guess the Wordle in 6 tries."
        label.textColor = UIColor.label
        return label
    }()
    
    private var firstRuleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Each guess must be a valid 5-letter word."
        label.textColor = UIColor.label
        return label
    }()
    
    private var secondRuleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The color of the tiles will change to show how close your guess was to the word."
        label.numberOfLines = 0
        label.textColor = UIColor.label
        return label
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(secondaryLabel)
        view.addSubview(firstRuleLabel)
        view.addSubview(secondRuleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            secondaryLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            secondaryLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            firstRuleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            firstRuleLabel.topAnchor.constraint(equalToSystemSpacingBelow: secondaryLabel.bottomAnchor, multiplier: 2),
            secondRuleLabel.topAnchor.constraint(equalToSystemSpacingBelow: firstRuleLabel.bottomAnchor, multiplier: 1),
            secondRuleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: secondRuleLabel.trailingAnchor, multiplier: 2),
            
        ])
    }
    
    // MARK: - Selectors
}
