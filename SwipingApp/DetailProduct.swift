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
    var detailProductImages: [UIImage]

    init(productBrand: String, productName: String, productPrice: Float, productImage: UIImage, productCode: String, productColor: String, detailProductDescription: String, detailProductImages: [UIImage]) {
        
        
        self.detailProductDescription = detailProductDescription
        self.detailProductImages = detailProductImages
      
        super.init(productBrand: productBrand, productName: productName, productPrice: productPrice, productImage: productImage, productCode: productCode, productColor: productColor)
        
    }
    
}
