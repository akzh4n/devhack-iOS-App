//
//  ServicesTableViewCell.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var executionTimeLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func set(object: ServiceModel) {
        self.reasonLabel.text = object.reason
        self.executionTimeLabel.text = object.executionTime
        self.performerLabel.text = object.performer
        self.statusLabel.text = object.status
    }

   

}
