//
//  SettingsCell.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 04..
//

import UIKit

enum SettingsCellType {
    case darkmode, link, simple, logout
}

class SettingsCell: UITableViewCell {
    
    static let identifier = "SettingsCell"
        
    private let darkModeSwitcher = UISwitch()
    public var type = SettingsCellType.simple
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if let darkMode = UserDefaults.standard.value(forKey: "DarkMode") {
            darkModeSwitcher.isOn = darkMode as! Bool
        }
        
        darkModeSwitcher.translatesAutoresizingMaskIntoConstraints = false
        darkModeSwitcher.addTarget(self, action: #selector(darkModeSwitcherChanged), for: .valueChanged)
        darkModeSwitcher.isUserInteractionEnabled = true
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, type: SettingsCellType) {
        self.cellLabel.text = title
        
        switch type {
        case .darkmode:
            self.type = .darkmode
            contentView.addSubview(darkModeSwitcher)
            NSLayoutConstraint.activate([
                self.trailingAnchor.constraint(equalToSystemSpacingAfter: darkModeSwitcher.trailingAnchor, multiplier: 2),
                darkModeSwitcher.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        case .link:
            cellLabel.textColor = .link
            self.type = .link
        case .simple:
            cellLabel.textColor = .label
            self.type = .simple
        case .logout:
            cellLabel.textColor = .systemRed
            self.type = .logout
        }
    }
    
    private func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc func darkModeSwitcherChanged() {
        if darkModeSwitcher.isOn {
            window?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.setValue(true, forKey: "DarkMode")
        } else {
            window?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.setValue(false, forKey: "DarkMode")
        }
    }
}
