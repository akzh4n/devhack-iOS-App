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
        self.serviceTypeLabel.text = object.serviceType
        self.serviceCostLabel.text = object.serviceCost
        self.serviceExecutionTImeLabel.text = object.serviceExecutionTime
    }

   

}
