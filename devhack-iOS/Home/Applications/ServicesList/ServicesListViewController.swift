//
//  ServicesListViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class ServicesListViewController: UIViewController {


    @IBOutlet weak var leaveApplicationButton: UIButton!
    
    @IBOutlet weak var applicationListView: UIView!
    
    
    @IBOutlet weak var SanAndCommButton: UIButton!
    
    @IBOutlet weak var smallRepairButton: UIButton!
    
    @IBOutlet weak var electroButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        leaveApplicationButton.backgroundColor = .redColor
        leaveApplicationButton.layer.cornerRadius = 10
        
        
        applicationListView.backgroundColor = .tableViewCardColor
        
        
        SanAndCommButton.backgroundColor = .redColor
        SanAndCommButton.layer.cornerRadius = 10
        
        smallRepairButton.backgroundColor = .redColor
        smallRepairButton.layer.cornerRadius = 10
        
        electroButton.backgroundColor = .redColor
        electroButton.layer.cornerRadius = 10
        
        
        
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openSanComList" {
            if let destinationVC = segue.destination as? ServiceListTableViewController {
                destinationVC.headerText = SanAndCommButton.currentTitle
            }
        }
        
        if segue.identifier == "openSmallRepairList" {
            if let destinationVC = segue.destination as? ServiceListTableViewController {
                destinationVC.headerText = smallRepairButton.currentTitle
            }
        }
        
        if segue.identifier == "openElectroList" {
            if let destinationVC = segue.destination as? ServiceListTableViewController {
                destinationVC.headerText = electroButton.currentTitle
            }
        }
       
    }

    


}
