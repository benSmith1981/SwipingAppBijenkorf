//
//  MainCategoryTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 17-11-16.
//
//

import Foundation
import UIKit
import Alamofire
import GGLAnalytics

class MainCategoryTableViewController: UITableViewController {
    
    var dictArray = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "bijenkorfNavigationLogo.png")
        self.navigationItem.titleView = UIImageView(image: image)
        
        DataManager.sharedInstance.getDataFromAPI()
        
        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (notification) in
            let dictObj = notification.object as! Dictionary<String, Any>
            
            for (_, i) in dictObj {
                self.dictArray.append(i as! [String : Any])
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dictArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var dictObj = self.dictArray[indexPath.row]
        cell.textLabel?.text = dictObj["name"] as! String?
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = tableView.indexPathForSelectedRow?.row
        let currentDict = dictArray[index!]
        
        if segue.identifier == "mainToSub" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                
                var dictObj = dictArray[row]
                let subCatTableViewController = segue.destination as! SubCategoryTableViewController
                subCatTableViewController.dict = currentDict
                subCatTableViewController.title = dictObj["name"] as? String
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.title = "Bijenkorf"
//        navigationItem.titleView = UIImage(named: "bijenkorfNavigationLogo.png")
        navigationController?.navigationBar.barTintColor = UIColor(red: 238, green: 238, blue: 238, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.setScreenName(name: "Bijenkorf")
        
    }
    
}

extension UIViewController {
    
    func setScreenName(name: String) {
        self.title = name
        self.sendScreenView()
    }
    
    func sendScreenView() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: self.title)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        let dictionary = (builder?.build())! as NSMutableDictionary
        tracker?.send(dictionary as [NSObject: AnyObject]!)
    }

    
}

