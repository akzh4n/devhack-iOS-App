//
//  ServiceListTableViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class ServiceListTableViewController: UITableViewController {

    
    
    var model: ServiceModel?
    var headerText: String?
    var serviceObjects = [ServiceModel]()
    var filteredObjects = [ServiceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView?.backgroundColor = .redColor
        tableView.tableHeaderView?.tintColor = .redColor
        tableView.backgroundColor = .backgroundColor
        
        
        
        ApplicationNetworkService.shared.getMyFilteredServices { [unowned self] model in
            DispatchQueue.main.async { [self] in
                
                for item in model {
                    if let price = item.price,
                       let timeToComplete = item.time_to_complete,
                       let typeName = item.name{
                        let service = ServiceModel(serviceType: typeName, serviceCost: String(price), serviceExecutionTime: timeToComplete)
                        self.serviceObjects.append(service)
                        self.tableView.updateConstraints()
                        self.tableView.reloadData()
                        
                    }
                }
            }
        }
        
        
        
    }

    // MARK: - Table view data source

  
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let headerText = headerText else { return nil }
        
        let attributedString = NSMutableAttributedString(string: headerText)
        let range = NSRange(location: 0, length: headerText.count)
        let font = UIFont(name: "Montserrat-Medium.ttf", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        attributedString.addAttributes(attributes, range: range)
        
        return attributedString.string
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return serviceObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! ServicesTableViewCell
        let object = serviceObjects[indexPath.row]
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.cornerRadius = 5.0
        cell.set(object: object)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .redColor
            headerView.backgroundView?.backgroundColor = .redColor
            headerView.textLabel?.textColor = .white
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
   

    
    
   

}
