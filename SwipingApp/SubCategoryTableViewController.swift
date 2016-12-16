//
//  SubCategoryTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 17-11-16.
//
//

import Foundation
import UIKit
import Alamofire

class SubCategoryTableViewController: UITableViewController {
    
    var dict = Dictionary<String, Any>()
    var subCatArray = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dictObj = dict["categories"] as! Dictionary<String,Any>
        
        for (_, i) in dictObj {
            self.subCatArray.append(i as! [String : Any])
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCatArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMenuCell
        
        var dictObj = self.subCatArray[indexPath.row]
        let categoryString = dictObj["name"] as! String
        cell.subCatMenuLabel?.text? = categoryString.lowercased()
        cell.subCatMenuLabel?.font = UIFont(name: "ProximaNova-Regular", size: 18)
        self.tableView.separatorStyle = .none
        return cell
    }
    
    // this method should handle the clicking of the category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dictObj = subCatArray[indexPath.row]
        // check if it is empty
        let categories = dictObj["categories"] as! Dictionary<String,Any>
        if categories.count > 1 {
            let subCatTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "subCategoryVC") as! SubCategoryTableViewController
            subCatTableViewController.dict = dictObj
            subCatTableViewController.navigationItem.title = dictObj["name"] as? String
            self.navigationController?.pushViewController(subCatTableViewController, animated: true)
        } else {
            let detailTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "productVC") as! ChooseProductViewController
            detailTableViewController.dict = dictObj
            detailTableViewController.navigationItem.title = dictObj["name"] as? String
            self.navigationController?.pushViewController(detailTableViewController, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setScreenName(name: navigationItem.title!)
    }
}

