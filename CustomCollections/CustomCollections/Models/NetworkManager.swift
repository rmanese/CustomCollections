//  NetworkManager.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/21/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import Foundation

class NetworkManager {

    private let decoder = JSONDecoder()

    func fetchCollections(completionHandler: @escaping (([CustomCollection]?, Error?) -> Void)) {
        if let url = urlBuilder(query: "", path: "custom_collections.json?") {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let jsonCollections = try? self.decoder.decode(CustomCollections.self, from: data) {
                        completionHandler(jsonCollections.customCollections, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            }
            task.resume()
        }
    }

    func fetchCollects(id: Int, completionHandler: @escaping (([Collect]?, Error?) -> Void)) {
        if let url = urlBuilder(query: "collection_id=\(id)", path: "collects.json?") {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let jsonCollects = try? self.decoder.decode(Collects.self, from: data) {
                        completionHandler(jsonCollects.collects, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            }
            task.resume()
        }
    }

    func fetchProducts(ids: String, completionHandler: @escaping (([Product]?, Error?) -> Void)) {
        if let url = urlBuilder(query: "ids=\(ids)", path: "products.json?") {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let jsonProducts = try? self.decoder.decode(Products.self, from: data) {
                        completionHandler(jsonProducts.products, nil)
                    } else {
                        completionHandler(nil, error)
                    }
                }
            }
            task.resume()
        }
    }

    func urlBuilder(query: String, path: String) -> URL? {
        var urlString = ""
        let hostName = "https://shopicruit.myshopify.com/admin/"
        let queryItems: [String] = ["page=1", "access_token=c32313df0d0ef512ca64d5b336a0d7c6"]
        if query.isEmpty {
            urlString = hostName+path+queryItems.joined(separator: "&")
        } else {
            urlString = hostName+path+queryItems.joined(separator: "&")+"&\(query)"
        }
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}
