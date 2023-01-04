//
//  SceneDelegate.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 27..
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.window?.makeKeyAndVisible()
    }
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            self.goToController(with: LoginViewController(), withNav: true)
        } else {
            self.goToController(with: MainTabController(), withNav: false)
        }
    }
    
    private func goToController(with viewController: UIViewController, withNav: Bool) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                guard let strongSelf = self else { return }
                
                if withNav {
                    strongSelf.window?.rootViewController = UINavigationController(rootViewController: viewController)
                } else {
                    strongSelf.window?.rootViewController = viewController
                }
                
                strongSelf.window?.makeKeyAndVisible()
                
                UIView.animate(withDuration: 0.25) { [ weak self ] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
}

