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
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    
    @IBOutlet weak var payButton: UIButton!
    
    var spacePositions: [Int] { [3, 7, 11, 14] }
    
    
    var typeName: String?
    var price: String?
    var timeToComplete: String?
    
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceTypeLabel.text = typeName
        priceLabel.text = price
        executionTimeLabel.text = timeToComplete
        
        payButton.backgroundColor = .redColor
        payButton.layer.cornerRadius = 10
        
        
      
        
        
        nameTF.placeholderColor(color: .white)
        complexTF.placeholderColor(color: .white)
        categoryTF.placeholderColor(color: .white)
        apartmentTF.placeholderColor(color: .white)
        
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
    
    
    
   
    
    func startActivityView() {
 
        activityIndicatorView.startAnimating()
    }
    
    
    func stopActivityView() {
       
        activityIndicatorView.stopAnimating()
    }
    
    
    
    
    @IBAction func payButtonTapped(_ sender: Any) {
        
        startActivityView()
        
        guard !categoryTF.text!.isEmpty && !nameTF.text!.isEmpty && !apartmentTF.text!.isEmpty && !complexTF.text!.isEmpty else {
            self.showAlert(with: "Ошибка", and: "Пожалуйста заполните все поля!")
            return
        }
        
        
        goToLink()
        
        
        
    }
    
    func goToLink() {
        let title = serviceTypeLabel.text!
        let category = categoryTF.text!
        let price = priceLabel.text!.replacingOccurrences(of: " тг.", with: "")

        ApplicationNetworkService.shared.createPayment(title: title, category: category, price: price) { result in
            switch result {
            case .success(let url):
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    stopActivityView()
                    guard let url = URL(string: url) else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }

            case .failure(let failure):
                print(failure)
            }
        }
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
