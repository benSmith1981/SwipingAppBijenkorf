//
//  Constants.swift
//  SwipingApp
//
//  Created by Thijs Lucassen on 12-12-16.
//
//

import Foundation

let baseURL = "https://ceres-catalog.debijenkorf.nl/catalog/navigation/"

typealias productReturnValue = ([Product], String) -> Void

enum jsonKeys: String {
    
    case data
    case name
    case categories
    case products
    case pagination
    case query
    case nextPage
}


