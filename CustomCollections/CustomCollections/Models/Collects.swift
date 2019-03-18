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
