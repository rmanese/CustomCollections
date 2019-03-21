//
//  Products.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/16/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import Foundation

class Products: Codable {
    var products: [Product]
}

class Product: Codable {
    var title: String
    var variants: [Variant]

    func countQuantity(variants: [Variant]) -> Int {
        var total = 0
        for variant in variants {
            total += variant.inventoryQuantity
        }
        return total
    }
}

class Variant: Codable {
    var price: String
    var inventoryQuantity: Int
}
