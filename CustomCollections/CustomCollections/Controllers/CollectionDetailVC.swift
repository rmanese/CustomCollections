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
    private let productCellIdentifier = String(describing: ProductCell.self)
    private let cardCellIdentifier = String(describing: CardCell.self)

    var selectedCollection: CustomCollection?
    private var collectsArray = [Collect]()
    private var productsArray = [Product]()

    private let productCellID = "ProductCell"
    private let cardCellID = "CardCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(fetchCollects), with: nil)
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: self.productCellIdentifier, bundle: nil), forCellReuseIdentifier: self.productCellIdentifier)
        self.tableView.register(UINib(nibName: self.cardCellID, bundle: nil), forCellReuseIdentifier: self.cardCellID)
        self.tableView.tableFooterView = UIView()
    }

    @objc func fetchCollects() {
        guard let collection = selectedCollection else { return }
        self.networkManager.fetchCollects(id: collection.id) { [weak self] (fetchedCollects, _) in
            guard let self = self else { return }
            if let collects = fetchedCollects {
                self.collectsArray = collects
                self.fetchProducts(with: collects)
            }
        }
    }

    private func fetchProducts(with collects: [Collect]) {
        self.networkManager.fetchProducts(ids: collects.productIds, completionHandler: { [weak self] (fetchedProducts, _) in
            guard let self = self else { return }
            if let products = fetchedProducts {
                self.productsArray = products
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
            let cell = self.tableView.dequeueReusableCell(withIdentifier: self.productCellIdentifier) as! ProductCell
            cell.configure(collection: self.selectedCollection, product: self.productsArray[indexPath.row])
            return cell
        }
    }
}
