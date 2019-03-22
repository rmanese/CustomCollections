//
//  CollectionDetailVC.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/16/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class CollectionDetailVC: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    private let networkManager = NetworkManager()

    var selectedCollection: CustomCollection?
    private var collectsArray = [Collect]()
    private var productsArray = [Product]()

    private let productCellID = "ProductCell"
    private let cardCellID = "CardCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(fetchProducts), with: nil)
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.productCellID, bundle: nil), forCellReuseIdentifier: self.productCellID)
        self.tableView.register(UINib(nibName: self.cardCellID, bundle: nil), forCellReuseIdentifier: self.cardCellID)
        self.tableView.tableFooterView = UIView()
    }

    @objc func fetchProducts() {
        guard let collection = selectedCollection else { return }
        self.networkManager.fetchCollects(id: collection.id) { (fetchedCollects, _) in
            if let collects = fetchedCollects {
                self.collectsArray = collects
                let productIDs = self.concatProductIDs()
                self.networkManager.fetchProducts(ids: productIDs, completionHandler: { (fetchedProducts, _) in
                    if let products = fetchedProducts {
                        self.productsArray = products
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }

    private func concatProductIDs() -> String {
        var ids: String = ""
        for collect in self.collectsArray {
            ids += "\(collect.productId),"
        }
        ids.removeLast()
        return ids
    }

    //MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cardCellID) as! CardCell
            cell.configure(collection: self.selectedCollection)
            cell.collectionDescriptionTextViewHC.constant = cell.collectionDescriptionTextView.contentSize.height
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.productCellID) as! ProductCell
            cell.configure(collection: self.selectedCollection, product: self.productsArray[indexPath.row])
            return cell
        }
    }
}
