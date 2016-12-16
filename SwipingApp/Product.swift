//
//  Product.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 17-11-16.
//
//

import Foundation
import UIKit

class Product: NSObject {
    
    var productBrand: String
    var productName: String
    var productPrice: Float
    var productImage: UIImage?
    var productCode: String
    var productColor: String
    var productImageString: String = ""
    
    init(productBrand: String, productName: String, productPrice: Float, productImage: UIImage, productCode: String, productColor: String,  productImageString: String) {
        
        self.productBrand = productBrand
        self.productName = productName
        self.productPrice = productPrice
        self.productImage = productImage
        self.productCode = productCode
        self.productColor = productColor
        self.productImageString = productImageString

        super.init()
    }
    
    init(dict item:[String : AnyObject]) {
        self.productName = item["name"] as? String ?? "--"

        let brand = item["brand"] as? Dictionary<String,Any>
        self.productBrand = brand?["name"] as? String ?? "--"
        
        let sellingPrice = item["sellingPrice"] as! Dictionary<String,Any>
        self.productPrice = sellingPrice["value"] as! Float

        let currentVariantProduct = item["currentVariantProduct"] as! Dictionary<String,Any>
        let productCodeToCheck = currentVariantProduct["code"] as? String
        
        self.productCode = String(describing: productCodeToCheck!)
        self.productColor = currentVariantProduct["color"] as? String ?? "onbekend"
        
        if let imageURL = currentVariantProduct["images"] as? [Dictionary<String,Any>] {
            let imageProductURL = imageURL[0]
            let frontImageURL = imageProductURL["url"] as! String
            
            let httpURL = "https:\(frontImageURL)"
            let url = URL(string: httpURL)
            var data = try? Data(contentsOf: url!)
            
            self.productImageString = httpURL.replacingOccurrences(of: "default", with: "web_lister_2x")
                data = try? Data(contentsOf: URL(string: self.productImageString)!)
                if let data = data {
                    self.productImage = UIImage(data:data)

            }
         }
    }
    
}

