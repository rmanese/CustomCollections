//
//  CollectionDetailVC.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/16/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class CollectionDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var selectedCollection: CustomCollection?
    var collectsArray = [Collect]()
    var productsArray = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let collection = selectedCollection {
            self.title = collection.title.capitalized
        }

        performSelector(inBackground: #selector(fetchCollects), with: nil)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.tableView.tableFooterView = UIView()
    }

    @objc func fetchCollects() {
        guard let collection = selectedCollection else { return }
        let urlString = "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collection.id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    self.parseCollects(json: data)
                }
            }
            task.resume()
        }
    }

    @objc func fetchProducts() {
        let ids = concatProductIDs()
        let urlString = "https://shopicruit.myshopify.com/admin/products.json?ids=\(ids)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    self.parseProducts(json: data)
                }
            }
            task.resume()
        }
    }

    func parseCollects(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let jsonCollects = try? decoder.decode(Collects.self, from: json) {
            self.collectsArray = jsonCollects.collects
            fetchProducts()
        }
    }

    func parseProducts(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let jsonProducts = try? decoder.decode(Products.self, from: json) {
            self.productsArray = jsonProducts.products
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func concatProductIDs() -> String {
        var ids: String = ""
        for collect in self.collectsArray {
            ids += "\(collect.productId),"
        }
        ids.removeLast()
        return ids
    }

    func totalQuantity(product: Product) -> Int {
        var quantity = 0
        for variant in product.variants {
            quantity += variant.inventoryQuantity
        }
        return quantity
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        cell.configure(collection: self.selectedCollection, product: self.productsArray[indexPath.row])
        return cell
    }

}
