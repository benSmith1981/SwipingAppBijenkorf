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
    
    //    init(productBrand: String, productName: String, productPrice: Double, productImage: String) {
    
    init(productBrand: String, productName: String, productPrice: Float, productImage: UIImage) {
        
        self.productBrand = productBrand
        self.productName = productName
        self.productPrice = productPrice
        self.productImage = productImage
        
        
        super.init()
        
    }
    
}
