//
//  LeaderboardHeaderView.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 05..
//


import UIKit

protocol LeaderboardHeaderViewDelegate: AnyObject {
    func segmentChanged(with selectedIndex: Int)
}

class LeaderboardHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: LeaderboardHeaderViewDelegate?
    
    private let selectorSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Wins", "Win Percent", "Max Streak"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .clear
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
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
        backgroundColor = .systemBackground
        
        addSubview(selectorSegmentedControl)
        
        NSLayoutConstraint.activate([
            selectorSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorSegmentedControl.topAnchor.constraint(equalTo: topAnchor),
            selectorSegmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectorSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    // MARK: - Selectors
    
    @objc func handleSegmentChange() {
        delegate?.segmentChanged(with: selectorSegmentedControl.selectedSegmentIndex)
    }
}

