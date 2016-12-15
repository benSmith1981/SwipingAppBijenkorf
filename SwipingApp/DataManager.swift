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
import RealmSwift

let notificationName = Notification.Name("NotificationIdentifier")
let notificationQuery = Notification.Name("NotificationQuery")

class DataManager {
    
    static let sharedInstance = DataManager()
    let realm = try! Realm()
    lazy var realmProductArray: Results<RealmProduct> = { self.realm.objects(RealmProduct.self) }()
    var allProductCodes: RealmProduct!
    lazy var realmSeenProducts: Results<SeenProduct> = { self.realm.objects(SeenProduct.self) }()
    var seenProductCodes: SeenProduct!
    
    // MARK - Get data for menu categories
    
    func getDataFromAPI () {
        
        Alamofire.request("\(baseURL)tree?locale=nl_NL&excludeFields=refinementCount,selected,id,url,complete").responseJSON { response in
            
            if let JSON = response.result.value {
                let jsonDict = JSON as! Dictionary<String, Any>
                let jsonData = jsonDict[jsonKeys.data.rawValue] as! Dictionary<String, Any>
                let jsonCat = jsonData[jsonKeys.categories.rawValue] as! Dictionary<String, Any>
                
                NotificationCenter.default.post(name: notificationName, object: jsonCat)
            }
        }
    }
    
    func getFirstProductQuery(dict: Dictionary<String, Any>) -> String {
        let productQuery = dict["query"] as! String
        return productQuery
    }
    
    // MARK - Get data for ChooseProductViewController
    
    func loadProductWith(query: String, completion:@escaping productReturnValue) {
        
        ComparisonManager.sharedInstance.makeArrayOfStrings()
        
        var allProducts: [Product] = []
        let seenProducts = ComparisonManager.sharedInstance.seenProductArray
        
        Alamofire.request("\(baseURL)show?query=\(query)").responseJSON { response in
            
            DispatchQueue.global(qos: .background).async {
                
                let nextPage: Dictionary<String, Any>
                let nextPageURL: String?
                
                if let productJSON = response.result.value {
                    
                    let jsonDict = productJSON as! Dictionary<String, Any>
                    let jsonData = jsonDict[jsonKeys.data.rawValue] as! Dictionary<String, Any>
                    let jsonQuery = jsonData[jsonKeys.products.rawValue] as! [[String : AnyObject]]
                    let pageQuery = jsonData[jsonKeys.pagination.rawValue] as! Dictionary<String, Any>
                    if  let _nextPage = pageQuery[jsonKeys.nextPage.rawValue] as? Dictionary<String, Any> {
                        nextPage = _nextPage
                        nextPageURL = nextPage[jsonKeys.query.rawValue] as? String
                    } else {
                        nextPageURL = ""
                    }
                    
                    for item in jsonQuery {
                        // if we have not seen this product yet,
                        let currentVariantProduct = item["currentVariantProduct"] as! Dictionary<String,Any>
                        let productCodeToCheck = currentVariantProduct["code"] as! String
                        
                        if seenProducts.contains(productCodeToCheck) {
                            print("Already Seen")
                        } else {
                            // create the product
                            let product = Product(dict: item)
                            allProducts.append(product)
                            
                        }
                        DispatchQueue.main.async {
                            if allProducts.count == 2 {
                                completion(allProducts, nextPageURL!)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        completion(allProducts, nextPageURL!)
                    }
                }
            }
        }
    }

    // MARK - Get data for detailviewcontroller
    
    func getDetailProductFromAPI (code: String, completion:@escaping (_ detailProduct: DetailProduct) -> Void) {
        
        var newDetailProduct : DetailProduct?
        var imageURLArray: [UIImage] = []
        
        Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/product/list?productCodes=\(code)").responseJSON { response in
            
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
                    var productColor = ""
                    if let color = currentVariantProduct["color"] as? String {
                        productColor = color }
                    else {
                        productColor = "onbekend" }
                    
                    if let imageURL = currentVariantProduct["images"] as? [Dictionary<String,Any>] {
                        
                        for i in imageURL {
                            
                            let url = i["url"] as! String
                            let httpsURL = "https:\(url)"
                            
                            let webListerString = httpsURL.replacingOccurrences(of: "default", with: "web_lister_2x")
                            
                            let urlString = URL(string: webListerString)
                            let data = try? Data(contentsOf: urlString!)
                            let detailProductImage = UIImage(data: (data)!)
                            
                            imageURLArray.append(detailProductImage!)
                        }
                        
                        let detailProductImages = imageURLArray
                        let productImage = imageURLArray[0]
                        
                        newDetailProduct = DetailProduct(productBrand: productBrand!, productName: productName!, productPrice: productPrice, productImage: productImage, productCode: productCode!, productColor: productColor, detailProductDescription: detailProductDescription, detailProductImages: detailProductImages)
                        
                    }
                }
                completion(newDetailProduct!)
            }
            
        }
    }
}
