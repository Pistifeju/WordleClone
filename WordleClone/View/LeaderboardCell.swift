//
//  LeaderboardCell.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 04..
//

import UIKit


class LeaderboardCell: UITableViewCell {
    
    static let identifier = "LeaderboardCell"
        
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let winLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let winPercentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let maxStreakLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        let played = user.stats.wins + user.stats.losses
        let percent = Float(user.stats.wins) / Float(played) * 100.0
        let oneDecimalPercent = Float(String(format: "%.1f", percent))
        
        self.nameLabel.text = user.username
        self.winLabel.text = "\(user.stats.wins)"
        self.winPercentLabel.text = "\(oneDecimalPercent!)"
        self.maxStreakLabel.text = "\(user.stats.maxStreak)"
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(winLabel)
        addSubview(winPercentLabel)
        addSubview(maxStreakLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: maxStreakLabel.trailingAnchor, multiplier: 2),
            maxStreakLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: winPercentLabel.trailingAnchor, multiplier: 2),
            winPercentLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: winLabel.trailingAnchor, multiplier: 2),
            
            winLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            maxStreakLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            winPercentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
