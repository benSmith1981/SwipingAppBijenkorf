//
//  WishList.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 24-11-16.
//
//

import Foundation
import UIKit

class WishList {
    
    var productCodeArray: [String] = []
    var allProducts = [WishListProduct]()
    
    static let sharedInstance = WishList()
    
    func addNewProductCode(productCode: String) {
        
        productCodeArray.append(productCode)
    }
    
    func removeProductCode(index: Int) {
        
        productCodeArray.remove(at: index)
        
    }
    
//    func removeProductCode(item: WishListProduct) {
//        
//        if let index = productCodeArray.index(of: item) {
//            productCodeArray.remove(at: index)
//        }
//    }
    
}
