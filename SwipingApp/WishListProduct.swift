//
//  WishListProduct.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 28-11-16.
//
//

import Foundation
import UIKit

class WishListProduct: NSObject {
    

    var allProducts = [WishListProduct]()
    var productBrand: String
    var productName: String
    var productPrice: Float
    var productImage: UIImage
    var productCode: String
    
    //    init(productBrand: String, productName: String, productPrice: Double, productImage: String) {
    
    init(productBrand: String, productName: String, productPrice: Float, productImage: UIImage, productCode: String) {
        
        self.productBrand = productBrand
        self.productName = productName
        self.productPrice = productPrice
        self.productImage = productImage
        self.productCode = productCode
        
        super.init()
        
    }
    
    func removeProduct(item: WishListProduct) {
        
        if let index = allProducts.index(of: item) {
            allProducts.remove(at: index)
            
        }
    }
    
}
