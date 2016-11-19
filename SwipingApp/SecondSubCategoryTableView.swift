//
//  SecondSubCategoryTableView.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 17-11-16.
//
//

import Foundation
import UIKit
import Alamofire

class SecondSubCategoryTableViewController: UITableViewController {
    
    var dict = Dictionary<String, Any>()
    var secondSubCatArray = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dictObj = dict["categories"] as! Dictionary<String,Any>
        
        for (_, i) in dictObj {
            self.secondSubCatArray.append(i as! [String : Any])
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.secondSubCatArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        var dictObj = self.secondSubCatArray[indexPath.row]
        
        cell.textLabel?.text = dictObj["name"] as! String?
        
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = tableView.indexPathForSelectedRow?.row
        let currentDict = secondSubCatArray[index!]
        
        if segue.identifier == "subToDetail" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                
                var dictObj = secondSubCatArray[row]
                let detailTableViewController = segue.destination as! SwipingViewController
                detailTableViewController.dict = currentDict
                detailTableViewController.navigationItem.title = dictObj["name"] as? String
            }
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        let index = tableView.indexPathForSelectedRow?.row
//        let currentDict = secondSubCatArray[index!]
//        
//        if segue.identifier == "subToDetail" {
//            
//            if let row = tableView.indexPathForSelectedRow?.row {
//                
//                var dictObj = secondSubCatArray[row]
//                let detailTableViewController = segue.destination as! DetailTableViewController
//                detailTableViewController.dict = currentDict
//                detailTableViewController.navigationItem.title = dictObj["name"] as? String
//            }
//        }
//    }
    
    
}

