//
//  ServicesTableViewCell.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class ApplicationsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var executionTimeLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .tableViewCardColor
    }
    
    
    
    func set(object: ApplicationModel) {
        if object.reason == nil {
            let reasonText = "Протекает холодильник нужна помощь"
            self.reasonLabel.text = reasonText
        } else {
            self.reasonLabel.text = object.reason
        }
        
        if object.executionTime == nil {
            let executionTimeText = "1 день"
            self.executionTimeLabel.text = executionTimeText
        } else {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let day = Int(dateFormatter.string(from: currentDate)) ?? 0
            let remainingDays = max(0, Int(object.executionTime!)! - day)
            self.executionTimeLabel.text = "\(remainingDays) день"
        }
        
        
        
        if object.performer == nil {
            let performerText = "Калиматов Акжан"
            self.performerLabel.text = performerText
        } else {
            self.performerLabel.text = object.performer
        }
        
        
        if object.status == nil {
            let statusText = "В рассмотрении"
            self.statusLabel.text = statusText
        } else {
            self.statusLabel.text = object.status
        }
        
  
    }


   

}
