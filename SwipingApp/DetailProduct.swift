//
//  DetailProduct.swift
//  SwipingApp
//
//  Created by Frank Sanchez on 11/30/16.
//
//

import UIKit

class DetailProduct: WishListProduct {
    
    
    var detailProductDescription: String

    init(productBrand: String, productName: String, productPrice: Float, productImage: UIImage, productCode: String, detailProductDescription: String) {
        
        
        self.detailProductDescription = detailProductDescription
      
        super.init(productBrand: productBrand, productName: productName, productPrice: productPrice, productImage: productImage, productCode: productCode)
        
    }
    
}
