//
//  PayViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 26.03.2023.
//

import UIKit

class PayViewController: UIViewController {
    
    @IBOutlet weak var executionTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var serviceTypeLabel: UILabel!
    
    
    @IBOutlet weak var apartmentTF: UITextField!
    @IBOutlet weak var complexTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    
    @IBOutlet weak var payButton: UIButton!
    
    var spacePositions: [Int] { [3, 7, 11, 14] }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payButton.backgroundColor = .redColor
        payButton.layer.cornerRadius = 10
        
        
        phoneNumberTF.addTarget(self, action: #selector(phoneTextFieldChanged), for: .editingChanged)
        phoneNumberTF.delegate = self
        
        
        
        nameTF.placeholderColor(color: .white)
        complexTF.placeholderColor(color: .white)
        phoneNumberTF.placeholderColor(color: .white)
        apartmentTF.placeholderColor(color: .white)
        
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
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

        let keyboardHeight = keyboardFrame.size.height
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardHeight {
            let distance = textFieldBottomY - keyboardHeight
            view.frame.origin.y = -distance
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
    
    
    
    @IBAction func payButtonTapped(_ sender: Any) {
        
        guard !phoneNumberTF.text!.isEmpty && !nameTF.text!.isEmpty && !apartmentTF.text!.isEmpty && !complexTF.text!.isEmpty else {
            self.showAlert(with: "Ошибка", and: "Пожалуйста заполните все поля!")
            return
        }
        self.showAlert(with: "Отлично", and: "Вы успешно оплатили!") {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    
}


extension PayViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 { textField.text = "+7 7" }
        return true
    }
}



// Extenstion for special alerts

extension PayViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
