//
//  ApplicationsViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class ApplicationsViewController: UIViewController {
    
    @IBOutlet weak var segmentsBackground: UIView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var addServiceButton: UIButton!
    @IBOutlet weak var serviceBackgroundView: UIView!
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var applicationTableView: UITableView!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var applicationObjects = [ApplicationModel]()
    var historyObjects = [ApplicationModel]()
    
    var totalObjects = [ApplicationModel]()
    
    
    var model: ApplicationModel?
    
    private var activityIndicatorView: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        self.view.backgroundColor = .backgroundColor
        
        topView.backgroundColor = .topViewBackgroundColor
        
        
        segmentsBackground.backgroundColor = .topViewBackgroundColor
        
        serviceBackgroundView.backgroundColor = .redColor
        
        
        addServiceButton.layer.cornerRadius = 20
        addServiceButton.clipsToBounds = true
        addServiceButton.backgroundColor = .white
        addServiceButton.tintColor = .redColor
        
        
        
        exitButton.layer.cornerRadius = 22.5
        exitButton.clipsToBounds = true
        exitButton.backgroundColor = .redColor
        
        segmentedControl.backgroundColor = .backgroundColor
        segmentedControl.selectedSegmentTintColor = .redColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        applicationTableView.delegate = self
        applicationTableView.dataSource = self
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        
        
        ApplicationNetworkService.shared.getMyApplications { [unowned self] model in
            DispatchQueue.main.async { [self] in
//                var objects: [ApplicationModel] = []
//
                print("Our: \(model)")
                for item in model {
                    if let reason = item.title,
                       let executor = item.executor,
                       let status = item.status,
                       let date = item.date {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let dayFormatter = DateFormatter()
                        dayFormatter.dateFormat = "dd"
                        
                        let executionDate = dateFormatter.date(from: date) ?? Date()
                        let executionTime = dayFormatter.string(from: executionDate)
                        let application = ApplicationModel(reason: reason, executionTime: executionTime, performer: executor, status: status)
                        
                        
                        self.applicationObjects.append(application)
                        print("Application: \(application)")
                        totalObjects = applicationObjects + historyObjects
            
                        self.applicationObjects = self.totalObjects.filter { $0.status != "Выполнено" }
                        self.historyObjects = self.totalObjects.filter { $0.status == "Выполнено" }
                        
                        self.applicationTableView.reloadData()
                        self.applicationTableView.updateConstraints()
                        
                        
                        self.historyTableView.reloadData()
                        self.historyTableView.updateConstraints()
                        
                    }
                }
                
                
            
                
            }
        }
        
        
        applicationTableView.backgroundColor = .backgroundColor
        historyTableView.backgroundColor = .backgroundColor
        
        
        
        
     
        
        historyTableView.allowsSelection = false
        applicationTableView.allowsSelection = false
        
     
        
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
    
    
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            applicationTableView.reloadData()
        case 1:
            historyTableView.reloadData()
        default:
            break
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


extension ApplicationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            if applicationObjects.count == 0 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                label.text = "У вас нету активных заявок"
                label.font = UIFont(name: "Montserrat-Medium", size: 16)
                label.textColor = .gray
                label.textAlignment = .center
                tableView.backgroundView = label
            } else {
                tableView.backgroundView = nil
            }
            return applicationObjects.count
        } else {
            if historyObjects.count == 0 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                label.text = "Ваша история пуста"
                label.font = UIFont(name: "Montserrat-Medium", size: 16)
                label.textColor = .gray
                label.textAlignment = .center
                tableView.backgroundView = label
            } else {
                tableView.backgroundView = nil
            }
            return historyObjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "applicationCell", for: indexPath) as! ApplicationsTableViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let application = applicationObjects[indexPath.row]
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.cornerRadius = 5.0
            cell.set(object: application)
        } else {
            let history = historyObjects[indexPath.row]
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.cornerRadius = 5.0
            cell.set(object: history)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}


// Extenstion for special alerts

extension ApplicationsViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
