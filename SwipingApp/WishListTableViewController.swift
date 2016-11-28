//
//  WishListTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 21-11-16.
//
//

import UIKit

class WishListTableViewController: UITableViewController {
    
    var wishListProductArray = [WishListProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DataManager.sharedInstance.getProductsFromProductCodeAPI()
        
        NotificationCenter.default.addObserver(forName: notificationQuery, object: nil, queue: nil) { (notification) in
            let wishListObject = notification.object
            print(wishListObject)
            self.wishListProductArray = wishListObject as! [WishListProduct]
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListProductArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! CustomWishListTableViewCell
        
        var product = self.wishListProductArray[indexPath.row]
        let priceOfProduct = product.productPrice
        cell.productName?.text = product.productName
        cell.productBrand?.text = product.productBrand
        cell.productPrice?.text = String(format: "€ %.2f", priceOfProduct)
        cell.imageView?.image = product.productImage
        
        return cell
    }
}

