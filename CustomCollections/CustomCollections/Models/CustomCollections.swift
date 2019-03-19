//
//  CustomCollections.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/16/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import Foundation

class CustomCollections: Codable {
    var customCollections: [CustomCollection]
}

class CustomCollection: Codable {
    var id: Int
    var title: String
    var bodyHtml: String
    var image: Image
}

class Image: Codable {
    var src: String
}
