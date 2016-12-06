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
    var productImage: UIImage
    var productCode: String
    var productColor: String
    var productCategory: String
    var productImageString: String
    
    init(productBrand: String, productName: String, productPrice: Float, productImage: UIImage, productCode: String, productColor: String, productCategory: String, productImageString: String) {
        
        self.productBrand = productBrand
        self.productName = productName
        self.productPrice = productPrice
        self.productImage = productImage
        self.productCode = productCode
        self.productColor = productColor
        self.productCategory = productCategory
        self.productImageString = productImageString

        
        super.init()
        
    }
    
}

//init(dictionary: JSONDICT) {
//    
//    self.productBrand = dictionary["brand"]
//    self.productName = dictionary["name"]
//    self.productPrice = productPrice
//    self.productImage = productImage
//    self.productCode = productCode
//    
//    super.init()
