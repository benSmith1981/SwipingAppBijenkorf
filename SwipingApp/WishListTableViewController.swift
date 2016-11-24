//
//  WishListTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 21-11-16.
//
//

import UIKit

class WishListTableViewController: UITableViewController {
    
    var sharedWishList = WishList.sharedInstance
    var wishListArray: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishListArray = sharedWishList.productCodeArray
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return wishListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = wishListArray[indexPath.row]
        
        return cell
    }
    

    
}
