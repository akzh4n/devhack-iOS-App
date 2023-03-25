//
//  ServicesViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class ServicesViewController: UIViewController {

    @IBOutlet weak var segmentsBackground: UIView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var addServiceButton: UIButton!
    @IBOutlet weak var serviceBackgroundView: UIView!
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var applicationTableView: UITableView!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
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
    }
    


}
