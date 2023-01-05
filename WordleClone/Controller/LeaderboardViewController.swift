//
//  LeaderboardViewController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    // MARK: - Properties
    
    private let refreshControl = UIRefreshControl()
    
    private var users: [User]?
    
    private let headerView = LeaderboardHeaderView(frame: .zero)
    
    private let leaderBoardTableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.backgroundColor = .systemBackground
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.rowHeight = 50
        tb.isScrollEnabled = true
        return tb
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        leaderBoardTableView.refreshControl = refreshControl
        
        fetchAllUsers()
        
        leaderBoardTableView.delegate = self
        leaderBoardTableView.dataSource = self
        leaderBoardTableView.register(LeaderboardCell.self, forCellReuseIdentifier: LeaderboardCell.identifier)
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .yellow
        
        view.addSubview(leaderBoardTableView)
        
        navigationItem.title = "Leaderboard"
        
        NSLayoutConstraint.activate([
            leaderBoardTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leaderBoardTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leaderBoardTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leaderBoardTableView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    private func fetchAllUsers() {
        UserService.shared.fetchAllUsers { [weak self] users, error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showFetchingAllUsersErrorAlert(on: strongSelf, with: error)
            }
            
            strongSelf.users = users
            strongSelf.leaderBoardTableView.reloadData()
        }
    }
    
    // MARK: - Selectors
    
    @objc private func refreshUsers() {
        fetchAllUsers()
        self.refreshControl.endRefreshing()
    }
}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardCell.identifier, for: indexPath) as! LeaderboardCell
        if let user = self.users?[indexPath.row] {
            cell.configure(with: user)
        }
        
        return cell
    }
}
