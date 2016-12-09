//
//  AlgorithmManager.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 08-12-16.
//
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

class AlgorithmManager {
    
    
    static let sharedInstance = AlgorithmManager()
    
//    let realm = try! Realm()
//    lazy var realmProductArray: Results<RealmProduct> = { self.realm.objects(RealmProduct.self) }()
//    var allProductCodes: RealmProduct!
//    
//    func getColorDataFromRealm() {
//        
//        try! realm.write() {
//    
//    let colors = try! Realm().objects(RealmProduct.self)
//        print(colors)
//    let array = realmProductArray
//            
//        }
//        
//    }
    
    
}

extension Sequence where Self.Iterator.Element: Hashable {
    private typealias Element = Self.Iterator.Element
    
    func freq() -> [Element: Int] {
        return reduce([:]) { (accu: [Element: Int], element) in
            var accu = accu
            accu[element] = accu[element]?.advanced(by: 1) ?? 1
            return accu
        }
    }
}

extension Sequence where Self.Iterator.Element: Equatable {
    private typealias Element = Self.Iterator.Element
    
    func freqTuple() -> [(element: Element, count: Int)] {
        
        let empty: [(Element, Int)] = []
        
        return reduce(empty) { (accu: [(Element, Int)], element) in
            var accu = accu
            for (index, value) in accu.enumerated() {
                if value.0 == element {
                    accu[index].1 += 1
                    return accu
                }
            }
            
            return accu + [(element, 1)]
        }
    }
}

extension Results {
    func toArray () -> [Object] {
        var array = [Object]()
        for result in self {
            array.append(result)
        }
        return array
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}

