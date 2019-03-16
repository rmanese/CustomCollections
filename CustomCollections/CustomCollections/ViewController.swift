//
//  ViewController.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/16/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!

    var customCollections = [CustomCollection]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self

        performSelector(inBackground: #selector(fetchCollections), with: nil)

    }

    @objc func fetchCollections() {
        let url: URL = URL(string: "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let data = data {
                self.parse(json: data)
            }
        }
        task.resume()
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let jsonPetitions = try? decoder.decode(CustomCollections.self, from: json) {
            self.customCollections = jsonPetitions.customCollections
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
        let collection = self.customCollections[indexPath.row]

    }


}

