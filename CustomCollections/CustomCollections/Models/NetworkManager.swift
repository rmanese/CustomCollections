//
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
        let urlString: String = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        if let url = URL(string: urlString) {
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
        let urlString = "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        if let url = URL(string: urlString) {
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
        let urlString = "https://shopicruit.myshopify.com/admin/products.json?ids=\(ids)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        if let url = URL(string: urlString) {
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

}
