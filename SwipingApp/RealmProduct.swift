//
//  RealmProduct.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 06-12-16.
//
//

import Foundation
import UIKit
import RealmSwift

class RealmProduct: Object {
    
    dynamic var productName = ""
    dynamic var productBrand = ""
    dynamic var productImage = NSData()
    dynamic var productCode = ""
    dynamic var productPrice = 0.0

    let preferences = List<Preferences>()
}

class Preferences: Object {
    
    dynamic var productColor = ""
    dynamic var productCategory = ""
    dynamic var productBrand = ""
}

