//
//  ThirdSubCategoryTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 02-12-16.
//
//

import Foundation
import UIKit
import Alamofire

class ThirdSubCategoryTableViewController: UITableViewController {
    
    var dict = Dictionary<String, Any>()
    var thirdSubCatArray = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dictObj = dict["categories"] as! Dictionary<String,Any>
        
        for (_, i) in dictObj {
            self.thirdSubCatArray.append(i as! [String : Any])
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.thirdSubCatArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomMenuCell
        
        var dictObj = self.thirdSubCatArray[indexPath.row]
        let categoryString = dictObj["name"] as! String
        cell.thirdSubCatMenuLabel?.text? = categoryString.lowercased()
        self.tableView.separatorStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = tableView.indexPathForSelectedRow?.row
        let currentDict = thirdSubCatArray[index!]
        if segue.identifier == "thirdSubToSwipe" {
            if let row = tableView.indexPathForSelectedRow?.row {
                
                var dictObj = thirdSubCatArray[row]
                let detailTableViewController = segue.destination as! ChooseProductViewController
                detailTableViewController.dict = currentDict
                detailTableViewController.navigationItem.title = dictObj["name"] as? String
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setScreenName(name: navigationItem.title!)
    }
}


