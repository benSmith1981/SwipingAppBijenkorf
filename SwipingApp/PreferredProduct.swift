//
//  preferredProduct.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 02-12-16.
//
//

import Foundation
import UIKit

struct preferredProduct {
    
    var preferredProductColor: String
    var preferredProductCategory: String
    
    init(preferredProductColor: String, preferredProductCategory: String) {
        
        self.preferredProductColor = preferredProductColor
        self.preferredProductCategory = preferredProductCategory
    }
    
}
