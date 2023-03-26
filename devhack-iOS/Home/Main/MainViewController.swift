//
//  MainViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var exitButton: UIButton!
    
    
    @IBOutlet weak var importantCardView: UIView!
    
    @IBOutlet weak var attentionCardView: UIView!
    
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .backgroundColor
        
        importantCardView.backgroundColor = .anotherCardViewBackgroudColor
        attentionCardView.backgroundColor = .cardViewBackgroudColor
        importantCardView.layer.cornerRadius = 15
        attentionCardView.layer.cornerRadius = 15
        
        
        topView.backgroundColor = .topViewBackgroundColor
        
        exitButton.layer.cornerRadius = 22.5
        exitButton.clipsToBounds = true
        exitButton.backgroundColor = .redColor
     
        
        

       
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Initialize activity indicator view
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .white
        activityIndicatorView.center = view.center
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    

  
    
    func startActivityView() {
        view.alpha = 0.8
        activityIndicatorView.startAnimating()
    }
    
    
    func stopActivityView() {
        view.alpha = 1.0
        activityIndicatorView.stopAnimating()
    }
    

    @IBAction func exitButtonTapped(_ sender: Any) {
        
        
        startActivityView()
        AuthService.shared.logoutUser { [self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    stopActivityView()
                    self.showAlert(with: "Напоминание", and: "Вы вышли из аккаунта!") {
                        self.transitionToLogin()
                    }
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    // Go to LoginVC
    
    func transitionToLogin() {
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "NavigationLoginVC") as? UINavigationController
        view.window?.rootViewController = loginVC
        view.window?.makeKeyAndVisible()
    }
    
}

// Extenstion for special alerts

extension MainViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
