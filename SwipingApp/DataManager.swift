//
//  DataManager.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 17-11-16.
//
//

import Foundation
import Alamofire
import UIKit

let notificationName = Notification.Name("NotificationIdentifier")
let notificationQuery = Notification.Name("NotificationIdentifier")

class DataManager {
    
    static let sharedInstance = DataManager()
    
    
    func getDataFromAPI () {
        
        Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/navigation/tree?locale=nl_NL&excludeFields=refinementCount,selected,id,url,complete").responseJSON { response in
            
            if let JSON = response.result.value {
                
                let jsonDict = JSON as! Dictionary<String, Any>
                let jsonData = jsonDict["data"] as! Dictionary<String, Any>
                let jsonCat = jsonData["categories"] as! Dictionary<String, Any>
                
                
                
                NotificationCenter.default.post(name: notificationName, object: jsonCat)
                
            }
        }
    }
    
    //    func getQueryAPI () {
    //
    //        Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/navigation/show?query=").responseJSON { response in
    //
    //            if let JSON = response.result.value {
    //
    //                let jsonDict = JSON as! Dictionary<String, Any>
    //                let jsonData = jsonDict["data"] as! Dictionary<String, Any>
    //                let jsonQuery = jsonData["categories"] as! Dictionary<String, Any>
    //
    //
    //
    //                NotificationCenter.default.post(name: notificationQuery, object: jsonQuery)
    //                
    //            }
    //        }
    //    }
}
