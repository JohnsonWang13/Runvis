//
//  TabbarViewController.swift
//  Runvis
//
//  Created by 吳政緯 on 2017/5/25.
//  Copyright © 2017年 吳政緯. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index, viewController) in self.viewControllers!.enumerated() {
            
            switch index {
            case 0:
                let image = #imageLiteral(resourceName: "cloud").withRenderingMode(.alwaysOriginal)
                let selectedImage = #imageLiteral(resourceName: "cloudAct").withRenderingMode(.alwaysOriginal)
                let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
                tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                viewController.tabBarItem = tabBarItem
            case 1:
                let image = #imageLiteral(resourceName: "shoe").withRenderingMode(.alwaysOriginal)
                let selectedImage = #imageLiteral(resourceName: "shoeAct").withRenderingMode(.alwaysOriginal)
                let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
                tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                viewController.tabBarItem = tabBarItem
            case 2:
                let image = #imageLiteral(resourceName: "person").withRenderingMode(.alwaysOriginal)
                let selectedImage = #imageLiteral(resourceName: "personAct").withRenderingMode(.alwaysOriginal)
                let tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
                tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                viewController.tabBarItem = tabBarItem
                
            default:
                break
            }
        }
        
        self.selectedIndex = 1
    }
}
