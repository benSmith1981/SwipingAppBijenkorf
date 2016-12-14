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
        self.tableView.separatorStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = tableView.indexPathForSelectedRow?.row
        let currentDict = subCatArray[index!]
        
        if segue.identifier == "subToSub" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                
                var dictObj = subCatArray[row]
                let secondSubCatTableViewController = segue.destination as! SecondSubCategoryTableViewController
                secondSubCatTableViewController.dict = currentDict
                secondSubCatTableViewController.navigationItem.title = dictObj["name"] as? String
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setScreenName(name: navigationItem.title!)
    }
}

