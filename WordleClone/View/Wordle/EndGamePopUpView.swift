//
//  EndGamePopUpView.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 01..
//

import UIKit

protocol EndGamePopUpViewDelegate: AnyObject {
    func didTapMenu()
}

class EndGamePopUpView: UIView {
    
    // MARK: - Properties
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let winLoseLabel: UILabel = {
        let label = UILabel()
        label.text = "You Lost!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.tintColor = .label
        return label
    }()
    
    private let statisticsLabeL: UILabel = {
        let label = UILabel()
        label.text = "STATISTICS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .label
        return label
    }()
    
    private let menuButton = PopUpViewLeaveButton(with: "Menu")
    private let exitButton = PopUpViewLeaveButton(with: "Exit")
    
    private let statisticsNumStackView = PopUpViewStackView()
    private let statisticsStackView = PopUpViewStackView()
    
    private let playedNumLabel = CustomStatisticsLabel(with: "", isNumber: true)
    private let winPercentNumLabel = CustomStatisticsLabel(with: "", isNumber: true)
    private let currentStreakNumLabel = CustomStatisticsLabel(with: "", isNumber: true)
    private let maxStreakNumLabel = CustomStatisticsLabel(with: "", isNumber: true)
    private let playedLabel = CustomStatisticsLabel(with: "Played", isNumber: false)
    private let winPercentLabel = CustomStatisticsLabel(with: "Win %", isNumber: false)
    private let currentStreakLabel = CustomStatisticsLabel(with: "Current Streak", isNumber: false)
    private let maxStreakLabel = CustomStatisticsLabel(with: "Max Streak", isNumber: false)
    
    weak var delegate: EndGamePopUpViewDelegate?
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.frame = UIScreen.main.bounds
        
        menuButton.addTarget(self, action: #selector(didTapMenu), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(didTapExit), for: .touchUpInside)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        addSubview(container)
        container.addSubview(winLoseLabel)
        container.addSubview(statisticsLabeL)
        container.addSubview(statisticsNumStackView)
        container.addSubview(statisticsStackView)
        container.addSubview(menuButton)
        container.addSubview(exitButton)
        
        statisticsStackView.addArrangedSubview(playedLabel)
        statisticsStackView.addArrangedSubview(winPercentLabel)
        statisticsStackView.addArrangedSubview(currentStreakLabel)
        statisticsStackView.addArrangedSubview(maxStreakLabel)
        
        statisticsNumStackView.addArrangedSubview(playedNumLabel)
        statisticsNumStackView.addArrangedSubview(winPercentNumLabel)
        statisticsNumStackView.addArrangedSubview(currentStreakNumLabel)
        statisticsNumStackView.addArrangedSubview(maxStreakNumLabel)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            winLoseLabel.topAnchor.constraint(equalToSystemSpacingBelow: container.topAnchor, multiplier: 2),
            winLoseLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            statisticsLabeL.topAnchor.constraint(equalToSystemSpacingBelow: winLoseLabel.bottomAnchor, multiplier: 1),
            statisticsLabeL.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            statisticsNumStackView.topAnchor.constraint(equalToSystemSpacingBelow: statisticsLabeL.bottomAnchor, multiplier: 2),
            statisticsNumStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: container.leadingAnchor, multiplier: 2),
            container.trailingAnchor.constraint(equalToSystemSpacingAfter: statisticsNumStackView.trailingAnchor, multiplier: 2),
            statisticsNumStackView.heightAnchor.constraint(equalToConstant: 35),
            
            statisticsStackView.topAnchor.constraint(equalToSystemSpacingBelow: statisticsNumStackView.bottomAnchor, multiplier: 0),
            statisticsStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: container.leadingAnchor, multiplier: 2),
            container.trailingAnchor.constraint(equalToSystemSpacingAfter: statisticsStackView.trailingAnchor, multiplier: 2),
            statisticsStackView.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalToSystemSpacingAfter: container.leadingAnchor, multiplier: 2),
            container.bottomAnchor.constraint(equalToSystemSpacingBelow: menuButton.bottomAnchor, multiplier: 2),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 75),
            
            container.trailingAnchor.constraint(equalToSystemSpacingAfter: exitButton.trailingAnchor, multiplier: 2),
            container.bottomAnchor.constraint(equalToSystemSpacingBelow: exitButton.bottomAnchor, multiplier: 2),
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    public func setStatValues(with user: User) {
        self.maxStreakNumLabel.text = "\(user.stats.maxStreak)"
        self.currentStreakNumLabel.text = "\(user.stats.streak)"
        let played = user.stats.wins + user.stats.losses
        self.playedNumLabel.text = "\(played)"
        let percent = Float(user.stats.wins) / Float(played) * 100.0
        let oneDecimalPercent = Float(String(format: "%.1f", percent))
        self.winPercentNumLabel.text = "\(oneDecimalPercent!)"
    }
    
    func animateOut() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) { [weak self] complete in
            if complete {
                self?.removeFromSuperview()
            }
        }
    }
    
    func animateIn(didWin: Bool) {
        if didWin {
            winLoseLabel.text = "You Win!"
        } else {
            winLoseLabel.text = "You Lost!"
        }
        
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    // MARK: - Selectors
    
    @objc private func didTapMenu() {
        delegate?.didTapMenu()
    }
    
    @objc private func didTapExit() {
        animateOut()
    }
}

