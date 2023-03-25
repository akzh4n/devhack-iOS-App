//
//  MainViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var exitButton: UIButton!
    
    
    @IBOutlet weak var importantCardView: UIView!
    
    @IBOutlet weak var attentionCardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .backgroundColor
        
        importantCardView.backgroundColor = .anotherCardViewBackgroudColor
        attentionCardView.backgroundColor = .cardViewBackgroudColor
        importantCardView.layer.cornerRadius = 15
        attentionCardView.layer.cornerRadius = 15
        
        
        topView.backgroundColor = .topViewBackgroundColor
        
        exitButton.layer.cornerRadius = 22.5
        exitButton.clipsToBounds = true
        exitButton.backgroundColor = .redColor
     
        
        

       
    }
    

  


}
