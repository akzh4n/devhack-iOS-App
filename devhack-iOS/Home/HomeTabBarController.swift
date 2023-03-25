//
//  HomeTabBarController.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.barTintColor = .topViewBackgroundColor
        self.tabBar.backgroundColor = .topViewBackgroundColor
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     
        
        // move tab bar items down
        for item in tabBarController?.tabBar.items ?? [] {
             item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
             item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
         }
        
        
        // set red as selected background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: .redColor, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)

        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2

        
    }
    
}

