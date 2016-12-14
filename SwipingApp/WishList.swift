//
//  WishList.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 14-12-16.
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
}
