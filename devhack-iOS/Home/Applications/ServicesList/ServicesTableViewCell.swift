//
//  ServicesTableViewCell.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {
 
    @IBOutlet weak var serviceTypeLabel: UILabel!
    
    @IBOutlet weak var serviceCostLabel: UILabel!
    
    @IBOutlet weak var serviceExecutionTImeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .tableViewCardColor
    }
    
    
    func set(object: ServiceModel) {
        if object.serviceCost == nil {
            let serviceCostText = "0 тг."
            self.serviceCostLabel.text = serviceCostText
        } else {
            self.serviceCostLabel.text = "\(object.serviceCost) тг."
        }
        
        if object.serviceExecutionTime == nil {
            let serviceExecutionTimeText = "1 рабочий день"
            self.serviceExecutionTImeLabel.text = serviceExecutionTimeText
        } else {
            self.serviceExecutionTImeLabel.text = object.serviceExecutionTime
        }
        
        if object.serviceType == nil {
            let serviceTypeText = "Не указано"
            self.serviceTypeLabel.text = serviceTypeText
        } else {
            self.serviceTypeLabel.text = object.serviceType
        }
        
  
    }
   

}
