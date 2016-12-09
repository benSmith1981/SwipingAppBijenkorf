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
    
    dynamic var productCode = ""
    dynamic var productName = ""
    dynamic var productBrand = ""
    dynamic var productImage = NSData()
    dynamic var productPrice = 0.0

    let color = List<Color>()
    let brand = List<Brand>()
    let category = List<Category>()
    let seenProducts = List<SeenProduct>()
}

class Color: Object {
    dynamic var productColor = ""
}

class Brand: Object {
    dynamic var productBrand = ""
}

class Category: Object {
    dynamic var productCategory = ""
}

class SeenProduct: Object {
    dynamic var productCode = ""
}
