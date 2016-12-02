//
//  PreferredProductList.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 02-12-16.
//
//

import Foundation
import UIKit

class PreferredProductList {
    
    var preferredProductArray: [PreferredProduct] = []
    var allPreferredProducts = [PreferredProduct]()
    var preferredProduct: PreferredProduct!
    
    static let sharedInstance = PreferredProductList()
    
    func addNewPreferredProduct(newPreferredProduct: PreferredProduct) {
        
        preferredProductArray.append(newPreferredProduct)

    }

}
