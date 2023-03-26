//
//  SceneDelegate.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 24.03.2023.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let authService = AuthService()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "hasLaunched")
        let launchStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let isUserAuthenticated = AuthService.shared.isUserAuthenticated()
        var vc: UIViewController
        
        if(isUserAuthenticated == false) {
            vc = mainStoryboard.instantiateInitialViewController()!
        } else {
            vc = mainStoryboard.instantiateViewController(identifier: "HomeVC")
        }
        
        
        UserDefaults.standard.set(true, forKey: "hasLaunched")
        self.window?.rootViewController = vc
        
    }
    
    
   
    
    // GET USER DATA
    func getMe() {
        AuthService.shared.getUserData() { result in
            switch result {
            case .success(let userData):
                // Handle success
                print("Successfully updated and got: \(userData)")
            case .failure(let error):
                // Handle error
                print("Error by updating and getting: \(error)")
            }
        }
        
    }
    
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.global(qos: .background).async { [self] in
            getMe()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

