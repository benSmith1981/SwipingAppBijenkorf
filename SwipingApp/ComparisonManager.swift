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
    lazy var realmProductArray: Results<RealmProduct> = { self.realm.objects(RealmProduct.self) }()
    lazy var realmSeenProductArray: Results<SeenProduct> = { self.realm.objects(SeenProduct.self) }()
    
    var seenProductArray:[String] = []
    var stringArray = DataManager.sharedInstance.productCodeArray
    var uniqueArray: [String] = []
    var newArray: [String] = []


    func makeArrayOfStrings() {
        
        for product in realmSeenProductArray {
            let productCode = product.productCode
            seenProductArray.append(productCode)
        }
    }
    
    func combineArrays() {
        
        uniqueArray.append(contentsOf: seenProductArray)
        uniqueArray.append(contentsOf: stringArray)
    }
    
    func makeUniqueArray() {
        
        newArray.append(contentsOf: uniqueArray.uniq())
    }
}

extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}
