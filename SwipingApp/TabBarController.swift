//
//  TabBarController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 28-11-16.
//
//

import UIKit

class TabBarController: UITabBarController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarItemsCount = WishList.sharedInstance.productCodeArray.count
        print(tabBarItemsCount)
        let tabBarItemsString = String(tabBarItemsCount)
        let tabBarItems = tabBar.items! as [UITabBarItem]
        tabBarItems[1].badgeColor = UIColor.green
        tabBarItems[1].badgeValue = tabBarItemsString

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarItemsCount = WishList.sharedInstance.productCodeArray.count
        print(tabBarItemsCount)
        let tabBarItemsString = String(tabBarItemsCount)
        let tabBarItems = tabBar.items! as [UITabBarItem]
        tabBarItems[1].badgeColor = UIColor.green
        tabBarItems[1].badgeValue = tabBarItemsString
        
    }
}
