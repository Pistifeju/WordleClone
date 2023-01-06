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
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User, and selectedIndex: Int) {
        let played = user.stats.wins + user.stats.losses
        let percent = Float(user.stats.wins) / Float(played) * 100.0
        var oneDecimalPercent = Float(String(format: "%.1f", percent))
        
        if oneDecimalPercent!.isNaN {
            oneDecimalPercent = 0.0
        }
        
        var title = ""
        switch selectedIndex {
        case 0:
            title = "Wins: \(user.stats.wins)"
        case 1:
            title = "Win Percent: \(oneDecimalPercent!)%"
        case 2:
            title = "Max Streak: \(user.stats.maxStreak)"
        default:
            break
        }
        
        self.nameLabel.text = user.username
        self.titleLabel.text = title
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 2),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
