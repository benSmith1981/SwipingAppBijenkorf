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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.secondSubCatArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMenuCell
        
        var dictObj = self.secondSubCatArray[indexPath.row]
        let categoryString = dictObj["name"] as! String
        cell.secondSubCatMenuLabel?.text? = categoryString.lowercased()
        self.tableView.separatorStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = tableView.indexPathForSelectedRow?.row
        let currentDict = secondSubCatArray[index!]
        if segue.identifier == "secondToThird" {
            if let row = tableView.indexPathForSelectedRow?.row {
                
                var dictObj = secondSubCatArray[row]
                let thirdSubCatTableViewController = segue.destination as! ThirdSubCategoryTableViewController
                thirdSubCatTableViewController.dict = currentDict
                thirdSubCatTableViewController.navigationItem.title = dictObj["name"] as? String
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setScreenName(name: navigationItem.title!)
    }
}

