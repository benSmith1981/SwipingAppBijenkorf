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
//         self.tableView.register(cellClass: CustomMenuCell, forCellReuseIdentifier: "cell")
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
    
    // this method should handle the clicking of the category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dictObj = secondSubCatArray[indexPath.row]
        // check if it is empty
        let categories = dictObj["categories"] as! Dictionary<String,Any>
        if categories.count > 1 {
            let thirdSubCatTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "subCategoryVC") as! SecondSubCategoryTableViewController
            thirdSubCatTableViewController.dict = dictObj
            thirdSubCatTableViewController.navigationItem.title = dictObj["name"] as? String
            self.navigationController?.pushViewController(thirdSubCatTableViewController, animated: true)
        } else {
            let detailTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "productVC") as! ChooseProductViewController
            detailTableViewController.dict = dictObj
            detailTableViewController.navigationItem.title = dictObj["name"] as? String
            self.navigationController?.pushViewController(detailTableViewController, animated: true)
        }

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        let index = tableView.indexPathForSelectedRow?.row
//        let currentDict = secondSubCatArray[index!]
//        if segue.identifier == "secondToThird" {
//            if let row = tableView.indexPathForSelectedRow?.row {
//                
//                var dictObj = secondSubCatArray[row]
//                // check if it is empty
//                let categories = dictObj["categories"] as! Dictionary<String,Any>
//                if categories.count > 1 {
//                    let thirdSubCatTableViewController = segue.destination as! ThirdSubCategoryTableViewController
//                    thirdSubCatTableViewController.dict = currentDict
//                    thirdSubCatTableViewController.navigationItem.title = dictObj["name"] as? String
//                } else {
//                    let detailTableViewController = segue.destination as! ChooseProductViewController
//                    detailTableViewController.dict = currentDict
//                    detailTableViewController.navigationItem.title = dictObj["name"] as? String
//                }
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setScreenName(name: navigationItem.title!)
    }
}

