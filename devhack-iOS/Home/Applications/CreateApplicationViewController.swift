//
//  CreateApplicationViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class CreateApplicationViewController: UIViewController {

    @IBOutlet weak var createProblemTextView: UITextView!
    
    
    @IBOutlet weak var complexTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    
    
    @IBOutlet weak var sendApplicationButton: UIButton!
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    var spacePositions: [Int] { [3, 7, 11, 14] }
    
    

    private let categoryPickerView = UIPickerView()
    
    let categoryList = ["Сантехника и коммуникация", "Мелкий ремонт", "Электротехника"]
    var selectedCategory: String?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryTF.inputView = categoryPickerView
        
        
        
        sendApplicationButton.backgroundColor = .redColor
        sendApplicationButton.layer.cornerRadius = 10
        
        
        createProblemTextView.backgroundColor = .applicationFillColor
       
        titleTF.placeholderColor(color: .white)
        complexTF.placeholderColor(color: .white)
        categoryTF.placeholderColor(color: .white)
        priceTF.placeholderColor(color: .white)
        
        
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
    
    
    
  
    
    
    
      
      func startActivityView() {
          view.alpha = 0.8
          activityIndicatorView.startAnimating()
      }
      
      
      func stopActivityView() {
          view.alpha = 1.0
          activityIndicatorView.stopAnimating()
      }
      
    
    
    @IBAction func sendApplicationTapped(_ sender: Any) {
        
        startActivityView()
        let title = titleTF.text!
        let category = categoryTF.text!
        let description = createProblemTextView.text!
        guard let price = Int(priceTF.text ?? "") else {
            print("Price error")
            return
        }

        // Use the integer value here

        let status = "На рассмотрении"
        guard !priceTF.text!.isEmpty && !categoryTF.text!.isEmpty  && !complexTF.text!.isEmpty && !titleTF.text!.isEmpty else {
            self.showAlert(with: "Ошибка", and: "Пожалуйста заполните все поля!")
            stopActivityView()
            return
        }
        
        ApplicationNetworkService.shared.createApplication(description: description, title: title, category: category, price: price, status: status) { [self] result in
            switch result {
            case .success(let success):
                print("Успешно: \(success)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                    self.showAlert(with: "Отлично", and: "Вы успешно отправили заявку!") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                stopActivityView()
            case .failure(let failure):
                print("Ошибка: \(failure)")
            }
        }
        
     
        
       
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


extension CreateApplicationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoryList[row]
        categoryTF.text = selectedCategory
    }
}
