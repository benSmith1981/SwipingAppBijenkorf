//
//  ComparisonManager.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 09-12-16.
//
//

import Foundation
import RealmSwift

class ComparisonManager {
    
    static let sharedInstance = ComparisonManager()
    let realm = try! Realm()
    lazy var realmSeenProductArray: Results<SeenProduct> = { self.realm.objects(SeenProduct.self) }()
    var seenProductArray:[String] = []

    func makeArrayOfStrings() {
        for product in realmSeenProductArray {
            let productCode = product.productCode
            seenProductArray.append(productCode)
        }
    }
}


