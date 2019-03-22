//
//  ViewController.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/16/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class CustomCollectionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    private let networkManager = NetworkManager()
    private var customCollections = [CustomCollection]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()

        performSelector(inBackground: #selector(fetchCollections), with: nil)

    }

    @objc func fetchCollections() {
        self.networkManager.fetchCollections { [weak self] (customCollections, _) in
            guard let self = self else { return }
            if let fetchedCollections = customCollections {
                self.customCollections = fetchedCollections
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    //MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customCollections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = self.customCollections[indexPath.row].title.capitalized
        return cell
    }

    //MARK: - UITableViewDelegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = self.customCollections[indexPath.row]
        // change the hard string id for storyboard
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CollectionDetails") as? CollectionDetailVC {
            vc.selectedCollection = collection
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

}
