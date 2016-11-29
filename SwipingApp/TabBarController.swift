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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
