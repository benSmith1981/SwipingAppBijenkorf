//
//  RealmBasketProduct.swift
//  SwipingApp
//
//  Created by Frank Sanchez on 12/8/16.
//
//

import Foundation
import UIKit
import RealmSwift

class RealmBasketProduct: Object {
   
    dynamic var productName = ""
    dynamic var productBrand = ""
    dynamic var productImage = NSData()
    dynamic var productCategory = ""
    dynamic var productCode = ""
    dynamic var productPrice = 0.0
    dynamic var productColor = ""
}
