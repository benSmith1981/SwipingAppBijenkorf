//
//  DetailTableViewController.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 17-11-16.
//
//

import Foundation
import UIKit
import Alamofire

class DetailTableViewController: UITableViewController {
    
    //    var productURL: String?
    var dict = Dictionary<String, Any>()
    var productImageURL = UIImageView()
    var allProducts: [Product] = []
    //    var data: Data?
    //    var image = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productQuery = dict["query"] as! String
        
        Alamofire.request("https://ceres-catalog.debijenkorf.nl/catalog/navigation/show?query=\(productQuery)").responseJSON { response in
            
            if let productJSON = response.result.value {
                
                let jsonDict = productJSON as! Dictionary<String, Any>
                let jsonData = jsonDict["data"] as! Dictionary<String, Any>
                let jsonQuery = jsonData["products"] as! [[String : AnyObject]]
                let productItem = jsonQuery[0]
                
                
                for item in jsonQuery {
                    
                    // Data into object
                    
                    if let name = item["name"] as? String {
                        let brand = item["brand"] as? Dictionary<String,Any>
                        
                        if let productBrand = brand?["name"] as? String {
                        
                        
                        let sellingPrice = item["sellingPrice"] as! Dictionary<String,Any>
                        let productPrice = sellingPrice["value"] as! Double
                        
                        let currentVariantProduct = item["currentVariantProduct"] as! Dictionary<String,Any>
                            if let imageURL = currentVariantProduct["images"] as? [Dictionary<String,Any>] {
                        let imageProductURL = imageURL[0]
                        let frontImageURL = imageProductURL["url"] as! String
                        
                        let httpURL = "https:\(frontImageURL)"
                        
                        let newProduct = Product(productBrand: productBrand, productName: name, productPrice: productPrice, productImage: httpURL)
                        
                        self.allProducts.append(newProduct)
                    }
                    }
                    }
                    
                    
                }
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allProducts.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        
        let product = allProducts[indexPath.item]
        let priceOfProduct = product.productPrice
        
        // Convert url to image
        
        let url = URL(string: product.productImage)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            self.productImageURL.image = UIImage(data:(data)!)
        }
        
        cell.productBrand?.text = product.productBrand
        cell.productName?.text = product.productName
        cell.productPrice?.text = String(format: "€ %.2f", priceOfProduct)
        cell.productImage?.image = UIImage(data: data!)
        cell.backgroundColor = UIColor(red: 242, green: 242, blue: 242, alpha: 1)
        
        
        return cell
    }
    
    
    
}

