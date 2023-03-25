//
//  ServicesViewController.swift
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
    var objects:[ApplicationModel] = []
    
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
        
        
        applicationTableView.backgroundColor = .backgroundColor
        historyTableView.backgroundColor = .backgroundColor
        
        
        
        
        applicationTableView.delegate = self
        applicationTableView.dataSource = self
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
    }
    
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            applicationTableView.isHidden = false
            historyTableView.isHidden = true
        case 1:
            applicationTableView.isHidden = true
            historyTableView.isHidden = false
        default:
            break
        }
    }
    
    func setLabel(text: String) {
        
    }
    
    
}


extension ApplicationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows for each table view
        if tableView == applicationTableView {
            if objects.count == 0 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                label.text = "У вас нету активных заявок"
                label.font = UIFont(name: "Montserrat-Medium", size: 16)
                label.textColor = .gray
                label.textAlignment = .center
                tableView.backgroundView = label
            } else {
                tableView.backgroundView = nil
            }
            return objects.count
        } else if tableView == historyTableView {
            if objects.count == 0 {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                label.text = "Ваша история пуста"
                label.textColor = .gray
                label.textAlignment = .center
                tableView.backgroundView = label
            } else {
                tableView.backgroundView = nil
            }
            return objects.count 
        }
        return 0
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cells for each table view
        if tableView == applicationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "applicationCell", for: indexPath) as! ApplicationsTableViewCell
            let object = objects[indexPath.row]
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.cornerRadius = 5.0
            cell.set(object: object)
            return cell
        } else if tableView == historyTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "applicationCell", for: indexPath) as! ApplicationsTableViewCell
            let object = objects[indexPath.row]
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.cornerRadius = 5.0
            cell.set(object: object)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
