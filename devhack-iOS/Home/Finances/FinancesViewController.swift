//
//  FinancesViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//





// IT IS NOT PROPERPLY WORK
// JUST THERE ARE WAS NO ENOUGH TIME SO ALL STATIC AND TEST ><


import UIKit

class FinancesViewController: UIViewController {
    
    @IBOutlet weak var firstCostLabel: UILabel!
    
    @IBOutlet weak var secondCostLabel: UILabel!
    
    @IBOutlet weak var thirdCostLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var fourthVIew: UIView!
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        topView.backgroundColor = .topViewBackgroundColor
        exitButton.layer.cornerRadius = 22.5
        exitButton.clipsToBounds = true
        exitButton.backgroundColor = .redColor
        
        
        firstView.backgroundColor = .lightRedColor
        secondView.backgroundColor = .lightRedColor
        thirdView.backgroundColor = .lightRedColor
        fourthVIew.backgroundColor = .redColor
    
        addFirstView()
        addSecondView()
        addThirdView()
        addFourthView()
        
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
    
    func addFirstView() {
  
        let redHalfView = UIView(frame: CGRect(x: 0, y: 0, width: firstView.frame.width * 0.4, height: firstView.frame.height))
        redHalfView.backgroundColor = .lightRedColor
        
        let grayHalfView = UIView(frame: CGRect(x: firstView.frame.width * 0.4, y: 0, width: firstView.frame.width * 0.6, height: firstView.frame.height))
        grayHalfView.backgroundColor = .gray
        
     
        firstView.addSubview(redHalfView)
        firstView.addSubview(grayHalfView)
        
        firstView.addSubview(firstCostLabel)
        
    }
    
    
    func addSecondView() {
      
        let redHalfView = UIView(frame: CGRect(x: 0, y: 0, width: secondView.frame.width * 0.7, height: secondView.frame.height))
        redHalfView.backgroundColor = .lightRedColor
        
        let grayHalfView = UIView(frame: CGRect(x: firstView.frame.width * 0.7, y: 0, width: secondView.frame.width * 0.3, height: secondView.frame.height))
        grayHalfView.backgroundColor = .gray
        

        secondView.addSubview(redHalfView)
        secondView.addSubview(grayHalfView)
        
        secondView.addSubview(secondCostLabel)
    }
    
    
    func addThirdView() {
        
        let redHalfView = UIView(frame: CGRect(x: 0, y: 0, width: thirdView.frame.width * 0.9, height: thirdView.frame.height))
        redHalfView.backgroundColor = .lightRedColor
        
        let grayHalfView = UIView(frame: CGRect(x: thirdView.frame.width * 0.9, y: 0, width: thirdView.frame.width * 0.1, height: thirdView.frame.height))
        grayHalfView.backgroundColor = .gray
        

        thirdView.addSubview(redHalfView)
        thirdView.addSubview(grayHalfView)
        
        thirdView.addSubview(thirdCostLabel)
        
    }
    
    
    func addFourthView() {
        fourthVIew.backgroundColor = .lightRedColor
        
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

extension FinancesViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
