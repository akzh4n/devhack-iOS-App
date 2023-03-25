//
//  CreateApplicationViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class CreateApplicationViewController: UIViewController {

    @IBOutlet weak var createProblemTextView: UITextView!
    
    
    @IBOutlet weak var apartmentTF: UITextField!
    @IBOutlet weak var complexTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    @IBOutlet weak var sendApplicationButton: UIButton!
    
    
    var spacePositions: [Int] { [3, 7, 11, 14] }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendApplicationButton.backgroundColor = .redColor
        sendApplicationButton.layer.cornerRadius = 10
        
        
        createProblemTextView.backgroundColor = .applicationFillColor
        
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
    
    
    
    @IBAction func sendApplicationTapped(_ sender: Any) {
        
        guard !phoneNumberTF.text!.isEmpty && !nameTF.text!.isEmpty && !apartmentTF.text!.isEmpty && !complexTF.text!.isEmpty else {
            self.showAlert(with: "Ошибка", and: "Пожалуйста заполните все поля!")
            return
        }
        self.showAlert(with: "Отлично", and: "Вы успешно отправили заявку!") {
            self.navigationController?.popViewController(animated: true)
        }
        
       
    }
    

}


extension CreateApplicationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 { textField.text = "+7 7" }
        return true
    }
}



// Extenstion for special alerts

extension CreateApplicationViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
