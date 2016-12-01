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
let notificationQuery = Notification.Name("NotificationQuery")
let notificationDetail = Notification.Name("NotificationDetail")


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
    
    func getProductsFromProductCodeAPI () {
        
        var allWishListProducts: [AnyObject] = []
        let productCodeQuery = WishList.sharedInstance.productCodeArray
        let productCodeString = productCodeQuery.joined(separator: ",")
        
        Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/product/list?productCodes=\(productCodeString)").responseJSON { response in
            
            if let JSON = response.result.value {
                
                let jsonArray = JSON as! Dictionary<String, Any>
                let jsonData = jsonArray["data"] as! [[String : AnyObject]]
                
                for item in jsonData {
                    
                    let jsonProducts = item["product"] as! [String : AnyObject]
                    
                    let productName = jsonProducts["name"] as? String
                    let brand = jsonProducts["brand"] as? Dictionary<String,Any>
                    let productBrand = brand?["name"] as? String
                    
                    let currentVariantProduct = jsonProducts["currentVariantProduct"] as! Dictionary<String,Any>
                    let price = currentVariantProduct["sellingPrice"] as! Dictionary<String,Any>
                    let productPrice = price["value"] as! Float
                    let productCode = jsonProducts["code"] as? String
                    
                    if let imageURL = currentVariantProduct["images"] as? [Dictionary<String,Any>] {
                        let imageProductURL = imageURL[0]
                        let frontImageURL = imageProductURL["url"] as! String
                        
                        let httpURL = "https:\(frontImageURL)"
                        
                        let defaultString = httpURL
                        let webListerString = httpURL.replacingOccurrences(of: "default", with: "web_detail_2x")
                        
                        let url = URL(string: webListerString)
                        let data = try? Data(contentsOf: url!)
                        
                        var productImage : UIImage?
                        if data != nil {
                            productImage = UIImage(data:(data)!)
                        }
                        
                        let newWishListProduct = WishListProduct(productBrand: productBrand!, productName: productName!, productPrice: Float(productPrice), productImage: productImage!, productCode: productCode!)
                        
                        
                        allWishListProducts.append(newWishListProduct)
                    }
                }
                NotificationCenter.default.post(name: notificationQuery, object: allWishListProducts)
            }
            
        }
    }
    
    func getDetailProductFromAPI (completion:@escaping (_ detailProduct: DetailProduct) -> Void) {

        var newDetailProduct : DetailProduct?

        var detailProducts: [AnyObject] = []
        var imageURLArray: [UIImage] = []
        //        let productCodeQuery = WishList.sharedInstance.productCodeArray
        //        let productCodeString = productCodeQuery.joined(separator: ",")
        
        Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/product/list?productCodes=430504000486003").responseJSON { response in
            //430504000486003
            //208009011100000
            //208009011200000
            if let JSON = response.result.value {
                
                let jsonArray = JSON as! Dictionary<String, Any>
                let jsonData = jsonArray["data"] as! [[String : AnyObject]]
                
                for item in jsonData {
                    var detailProductDescription = ""
                    let jsonProducts = item["product"] as! [String : AnyObject]
                    
                    let productName = jsonProducts["name"] as? String
                    if let description = jsonProducts["description"] as? String {
                        detailProductDescription = description }
                    else {
                        detailProductDescription = "Helaas is er geen beschrijving beschikbaar"
                    }
                        let brand = jsonProducts["brand"] as? Dictionary<String,Any>
                        let productBrand = brand?["name"] as? String
                        
                        let currentVariantProduct = jsonProducts["currentVariantProduct"] as! Dictionary<String,Any>
                        let price = currentVariantProduct["sellingPrice"] as! Dictionary<String,Any>
                        let productPrice = price["value"] as! Float
                        let productCode = jsonProducts["code"] as? String
                        
                        if let imageURL = currentVariantProduct["images"] as? [Dictionary<String,Any>] {
                            
                            for i in imageURL {
                                
                                let url = i["url"] as! String
                                let httpsURL = "https:\(url)"
                                
                                let defaultString = httpsURL
                                let webListerString = httpsURL.replacingOccurrences(of: "default", with: "web_lister_2x")
                                
                                let urlString = URL(string: webListerString)
                                let data = try? Data(contentsOf: urlString!)
                                let detailProductImage = UIImage(data: (data)!)

                                imageURLArray.append(detailProductImage!)
                            }
                            
                            let detailProductImages = imageURLArray
                            let productImage = imageURLArray[0]

                            newDetailProduct = DetailProduct(productBrand: productBrand!, productName: productName!, productPrice: productPrice, productImage: productImage, productCode: productCode!, detailProductDescription: detailProductDescription, detailProductImages: detailProductImages)
                            
                        }
                    }
                completion(newDetailProduct!)
                }
            
            }
        
            
        }
    }
