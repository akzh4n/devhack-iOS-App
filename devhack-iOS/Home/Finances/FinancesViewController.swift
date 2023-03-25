//
//  FinancesViewController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//





// IT IS NOT PROPERPLY WORK
// JUST THERE ARE WAS NO ENOUGH TIME SO ALL STATIC AND TEST ><


import UIKit

class FinancesViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var fourthVIew: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        
        
        topView.backgroundColor = .topViewBackgroundColor
        
        exitButton.layer.cornerRadius = 22.5
        exitButton.clipsToBounds = true
        exitButton.backgroundColor = .redColor
        
        
        
        firstView.layer.cornerRadius = 20
        secondView.layer.cornerRadius = 20
        thirdView.layer.cornerRadius = 20
        fourthVIew.layer.cornerRadius = 20
        
        firstView.backgroundColor = .lightRedColor
        secondView.backgroundColor = .lightRedColor
        thirdView.backgroundColor = .lightRedColor
        fourthVIew.backgroundColor = .lightRedColor
      
    }
    
    
    
    


}
