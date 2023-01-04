//
//  SettingsViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let cellTypes = [
        "Dark Theme": SettingsCellType.darkmode,
        "Report A Bug": SettingsCellType.link,
        "Visit Our Help Center": SettingsCellType.link,
        "Contact Us": SettingsCellType.link,
        "About": SettingsCellType.simple,
    ]
    
    private let cellString = ["Dark Theme", "Report A Bug", "Visit Our Help Center", "Contact Us", "About"]
    
    private let settingsHeaderView = SettingsHeaderView(frame: .zero)
    
    private let settingsTableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.backgroundColor = .systemBackground
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.rowHeight = 50
        tb.isScrollEnabled = false
        
        return tb
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        navigationItem.title = "Settings"
        
        view.addSubview(settingsTableView)
        
        NSLayoutConstraint.activate([
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsTableView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    // MARK: - Selectors
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
        
        let cellString = self.cellString[indexPath.row]
        
        cell.configure(with: cellString, type: cellTypes[cellString] ?? .simple)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return settingsHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}
