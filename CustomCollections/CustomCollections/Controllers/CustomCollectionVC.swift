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

    var customCollections = [CustomCollection]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        performSelector(inBackground: #selector(fetchCollections), with: nil)

    }

    @objc func fetchCollections() {
        let urlString: String = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let data = data {
                    self.parse(json: data)
                }
            }
            task.resume()
        }

    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let jsonCollections = try? decoder.decode(CustomCollections.self, from: json) {
            self.customCollections = jsonCollections.customCollections
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    //MARK: - UITableViewDataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customCollections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.customCollections[indexPath.row].title
        return cell
    }

    //MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionID = self.customCollections[indexPath.row].id
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CollectionDetails") as? CollectionDetailVC {
            vc.collectionID = collectionID
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }


}

