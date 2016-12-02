//
//  WishListTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 21-11-16.
//
//

import UIKit
import UserNotifications

class WishListTableViewController: UITableViewController, UITabBarControllerDelegate {
    
    var wishListProductArray = [WishListProduct]()
    
    @IBAction func toggleEditingMode(_ sender: AnyObject) {
        
        if isEditing {
            sender.setTitle("Bewerk", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Klaar", for: .normal)
            setEditing(true, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.sharedInstance.getProductsFromProductCodeAPI()
        
        NotificationCenter.default.addObserver(forName: notificationQuery, object: nil, queue: nil) { (notification) in
            let wishListObject = notification.object
            
            self.wishListProductArray = wishListObject as! [WishListProduct]
            self.tableView.reloadData()
        }
        self.setScreenName(name: navigationItem.title!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListProductArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! CustomWishListTableViewCell
        
        let product = self.wishListProductArray[indexPath.row]
        let priceOfProduct = product.productPrice
        cell.productName?.text = product.productName
        cell.productBrand?.text = product.productBrand
        cell.productPrice?.text = String(format: "€ %.2f", priceOfProduct)
        cell.imageView?.image = product.productImage
        cell.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            WishList.sharedInstance.removeProductCode(index: indexPath.row)
        
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

