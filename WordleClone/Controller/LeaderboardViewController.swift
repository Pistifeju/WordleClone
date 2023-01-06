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
    
    private var selectedSegment = 0
    
    private var users: [User]?
    
    private let headerView = LeaderboardHeaderView(frame: .zero)
    
    private let leaderBoardTableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.backgroundColor = .systemBackground
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.rowHeight = 100
        tb.isScrollEnabled = true
        return tb
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        leaderBoardTableView.refreshControl = refreshControl
        
        headerView.delegate = self
        
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
            strongSelf.sortUsers()
        }
    }
    
    private func sortUsers() {
        switch self.selectedSegment {
        case 0:
            users?.sort(by: { user1, user2 in
                user1.stats.wins > user2.stats.wins
            })
        case 1:
            users?.sort(by: { user1, user2 in
                let played1 = user1.stats.wins + user1.stats.losses
                let percent1 = Float(user1.stats.wins) / Float(played1) * 100.0
                let oneDecimalPercent1 = Float(String(format: "%.1f", percent1))
                
                let played2 = user2.stats.wins + user2.stats.losses
                let percent2 = Float(user2.stats.wins) / Float(played2) * 100.0
                let oneDecimalPercent2 = Float(String(format: "%.1f", percent2))
                
                return oneDecimalPercent1! > oneDecimalPercent2!
            })
        case 2:
            users?.sort(by: { user1, user2 in
                user1.stats.maxStreak > user2.stats.maxStreak
            })
        default:
            break
        }
        
        self.leaderBoardTableView.reloadData()
    }
    
    // MARK: - Selectors
    
    @objc private func refreshUsers() {
        fetchAllUsers()
        self.refreshControl.endRefreshing()
    }
}

// MARK: - LeaderboardHeaderViewDelegate

extension LeaderboardViewController: LeaderboardHeaderViewDelegate {
    func segmentChanged(with selectedIndex: Int) {
        self.selectedSegment = selectedIndex
        sortUsers()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

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
            cell.configure(with: user, and: selectedSegment)
        }
        
        return cell
    }
}
