//
//  MainTabController.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(with: user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showFetchingUserErrorAlert(on: strongSelf, with: error)
                return
            }
            
            if let user = user {
                strongSelf.user = user
            }
        }
        
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        tabBar.isHidden = false
        tabBar.isTranslucent = false
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
    }
    
    private func configureViewControllers(with user: User) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let main = templateNavigationController(unselectedImage: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!, rootViewController: MainViewController(user: user))
        main.title = "Home"
        
        let settings = templateNavigationController(unselectedImage: UIImage(systemName: "gearshape")!, selectedImage: UIImage(systemName: "gearshape.fill")!, rootViewController: SettingsViewController())
        settings.title = "Settings"
        
        let leaderboard = templateNavigationController(unselectedImage: UIImage(systemName: "trophy")!, selectedImage: UIImage(systemName: "trophy.fill")!, rootViewController: LeaderboardViewController())
        leaderboard.title = "Leaderboard"
        
        viewControllers = [main, leaderboard, settings]
        
    }
    
    private func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .label
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.isHidden = false
        nav.navigationBar.backgroundColor = .systemBackground
        nav.navigationBar.tintColor = .black
        
        return nav
    }
}
