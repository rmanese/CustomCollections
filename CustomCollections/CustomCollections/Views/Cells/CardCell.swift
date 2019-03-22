//
//  CardCell.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/21/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var collectionTitleLabel: UILabel!
    @IBOutlet var collectionDescriptionLabel: UILabel!
    @IBOutlet var collectionImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        collectionTitleLabel.adjustsFontSizeToFitWidth = true

        mainView.layer.cornerRadius = 15
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 10
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5

        collectionImageView.layer.borderColor = UIColor.lightGray.cgColor
        collectionImageView.layer.borderWidth = 2
        collectionImageView.layer.cornerRadius = 5
    }

    override func prepareForReuse() {
        collectionImageView.image = nil
        collectionDescriptionLabel.text = ""
        collectionTitleLabel.text = ""
    }

    func configure(collection: CustomCollection?) {
        guard let collection = collection else { return }
        collectionTitleLabel.text = collection.title

        collectionDescriptionLabel.text = collection.bodyHtml.isEmpty ? "No description" : collection.bodyHtml
        loadImage(urlString: collection.image.src)
    }

    private func loadImage(urlString: String) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
                let imageData = try? Data(contentsOf: url),
                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.collectionImageView.image = image
                }
            }
        }
    }

}
