//
//  Collects.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/16/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import Foundation

class Collects: Codable {
    var collects: [Collect]
}

class Collect: Codable {
    var id: Int
    var productId: Int
}

extension Array where Element: Collect {
    var productIds: String {
        var ids = ""
        for collect in self {
            ids += "\(collect.productId),"
        }
        ids.removeLast()
        return ids
    }
}
