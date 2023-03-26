//
//  LoginViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 24.03.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    var spacePositions: [Int] { [3, 7, 11, 14] }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var goToRegisterBtn: UIButton!
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        goToRegisterBtn.tintColor = .redColor
        
        loginButton.layer.cornerRadius = 10
        
        phoneNumberTF.addTarget(self, action: #selector(phoneTextFieldChanged), for: .editingChanged)
        phoneNumberTF.delegate = self
        
        
        
        phoneNumberTF.placeholderColor(color: .systemGray6)
        passwordTF.placeholderColor(color: .systemGray5)
        
        
        // To remove keyboard by tapping view
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        
        
        
     
        
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
    
    // Keyboard settings to hide and show
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(sender:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // Special code to automatically resizing view with keyboard
    @objc func keyboardWillShow(sender: NSNotification) {
            guard let userInfo = sender.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                  let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
    }
    
    
    // PhoneTF
    
    @objc func phoneTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        if text.count == 0 { sender.text = "+7 7" }
        if spacePositions.contains(text.count),
           let last = text.last {
            sender.text?.removeLast()
            sender.text! += " \(last)"
        }
        
    }
    
    
    
  
    
    
    func startActivityView() {
        view.alpha = 0.8
        activityIndicatorView.startAnimating()
    }
    
    
    func stopActivityView() {
        view.alpha = 1.0
        activityIndicatorView.stopAnimating()
    }
    
    
    
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        
        startActivityView()
        
        guard Validators.isFilledLog(phonenumber: phoneNumberTF.text, password: passwordTF.text) else {
            self.showAlert(with: "Ошибка", and: "Пожалуйста, заполните все поля!")
            stopActivityView()
            return
        }
        
        let phone = phoneNumberTF.text!
        let password = passwordTF.text!
        
        AuthService.shared.loginUser(phoneNumber: phone, password: password) { [self] result in
         
            switch result {
            case .success(let success):
                print(success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    stopActivityView()
                    self.showAlert(with: "Отлично", and: "Вы вошли в аккаунт!") {
                        self.transitionToHome()
                    }
                }
            case .failure(let failure):
                print(failure)
                self.showAlert(with: "Ошибка", and: "Пожалуйста, попробуйте еще раз")
            }
        }
    }
    
    
    
    // Go to HomeVC
    
    func transitionToHome() {
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeTabBarController
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    
    
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 { textField.text = "+7 7" }
        return true
    }
}


// Extenstion for special alerts

extension LoginViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


