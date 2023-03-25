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

    
    
    
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 { textField.text = "+7 7" }
        return true
    }
}




